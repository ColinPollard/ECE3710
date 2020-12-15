import sys
from constants import opcodes
from constants import registers
from constants import conditions

DEBUG = False

def readASM(file):
    """Reads all of the lines from the assembly file

    Args:
        file (str): name of the file

    Returns:
        List: each line of the assembly file
    """
    with open(file, 'r') as f:
        asmInstructions = f.readlines()
        return asmInstructions
    
def writeBinFile(machineInstructions, filename):
    filename = filename.split('.')[0]
    filename += 'B.txt'
    with open(filename, 'w') as f:
        for instr in machineInstructions:
            f.write(instr + '\n')

def encodeIType(instrName, imm, rdest):
    instr = opcodes[instrName]
    instr += registers[rdest]

    if instrName == 'LSHI':
        instr += '000'
        instr += format(int(imm), '05b')
    else:
        imm = int(imm)
        if(imm < 0):
            instr += format(imm % (1<<8), '08b')
        else:
            instr += format(imm, '08b')
    return instr

def encodeRType(instrName, rsrc, rdest):
    instr = opcodes[instrName][0]
    instr += registers[rdest]
    instr += opcodes[instrName][1]
    instr += registers[rsrc]
    return instr

def encodeBranchType(instrName, disp):
    instr = opcodes['Bcond']
    instr += conditions[instrName]
    num = int(disp)
    if(num < 0):
        instr += format(num % (1<<8), '08b')
    else:
        instr += format(num, '08b')
    return instr

def encodeLoadStoreType(instrName, rFirst, rAddr):
    instr = opcodes[instrName][0]
    instr += registers[rFirst]
    instr += opcodes[instrName][1]
    instr += registers[rAddr]
    return instr

if __name__ == "__main__":
    if(DEBUG):
        filename = 'ReportExample.txt'
    else:
        if len(sys.argv) != 2:
            print("Must enter the file name as an argument.")
    
        filename = sys.argv[1]
    asmInstructions = readASM(filename) 
    labels = {}
    addr = 0

    #loop once to compute the addresses of any jump labels
    for line in asmInstructions:
        instr = line.strip().upper()

        #ignore anything other than labels
        if instr == '' or instr[0] == '#':
            continue
        if instr[0] != '.':
            addr += 1
            continue

        instr = instr.split()[0]
        labels[instr[1:]] = addr
    
    addr = 0
    machineInstructions = []
    for instr in asmInstructions:

        #ignore blank lines
        if instr == '\n':
            continue

        instr = instr.strip().upper()

        #ignore comments and labels
        if instr[0] == '#' or instr[0] == '.':
            continue

        tokens = instr.split(' ')
        if tokens[0] in opcodes:
            instrName = tokens[0]
            if instrName[-1] == 'I':
                imm = tokens[1][1:-1] #strip off the comma and $
                rdest = tokens[2]
                machineInstructions.append(encodeIType(instrName, imm, rdest))
            elif instrName == 'BEQ' or instrName == 'BL' or instrName == 'JMP' or instrName == 'BOF':
                branchLabel = tokens[1].upper()
                branchAddr = labels[branchLabel]
                disp = branchAddr - addr
                machineInstructions.append(encodeBranchType(instrName, disp))
            elif instrName == 'LOAD' or instrName == 'STOR':
                rFirst = tokens[1][:-1] #strip off the comma
                rAddr = tokens[2]
                machineInstructions.append(encodeLoadStoreType(instrName, rFirst, rAddr))
            elif instrName == 'ENC1' or instrName == 'ENC2' or instrName == 'LOADDX' or instrName == 'LOADDY' or instrName == 'READPP':
                rdest = tokens[1]
                machineInstructions.append(encodeRType(instrName, 'R0', rdest))
            elif instrName == 'TRANSMIT':
                rsrc = tokens[1]
                machineInstructions.append(encodeRType(instrName, rsrc, 'R0'))

            else:
                rsrc = tokens[1][:-1] #strip off the comma
                rdest = tokens[2]
                machineInstructions.append(encodeRType(instrName, rsrc, rdest))

            addr += 1
    writeBinFile(machineInstructions, filename)



