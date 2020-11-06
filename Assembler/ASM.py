import sys
from constants import opcodes
from constants import registers
from constants import conditions

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
    
def writeBinFile(machineInstructions):
    with open("test1b.txt", 'w') as f:
        for instr in machineInstructions:
            f.write(instr + '\n')

def encodeIType(instrName, imm, rdest):
    instr = opcodes[instrName]
    instr += registers[rdest]

    if instrName == 'LSHI':
        instr += '000'
        instr += format(int(imm), '05b')
    else:
        instr += format(int(imm), '08b')
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
    instr += format(int(disp), '08b')
    return instr

def encodeLoadStoreType(instrName, rFirst, rAddr):
    instr = opcodes[instrName][0]
    instr += registers[rFirst]
    instr += opcodes[instrName][1]
    instr += registers[rAddr]
    return instr

if __name__ == "__main__":
    #if len(sys.argv) != 2:
    #    print("Must enter the file name as an argument.")
    
    #file = sys.argv[1]
    asmInstructions = readASM("test1.txt") 
    labels = {}
    addr = 0

    #loop once to compute the addresses of any jump labels
    for line in asmInstructions:
        instr = instr.strip().upper()

        #ignore anything other than labels
        if line[0] != '.':
            addr += 1
            continue

        labels[line[0][1:]] = addr
    
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
            elif instrName == 'BEQ' or instrName == 'BL' or instrName == 'JMP':
                branchLabel = tokens[1].upper()
                branchAddr = labels[branchLabel]
                disp = branchAddr - addr
                machineInstructions.append(encodeBranchType(instrName, disp))
            elif instrName == 'LOAD' or 'STORE':
                rFirst = tokens[1][:-1] #strip off the comma
                rAddr = tokens[2]
                machineInstructions.append(encodeLoadStoreType(instrName, rFirst, rAddr))
            else:
                rsrc = tokens[1][:-1] #strip off the comma
                rdest = tokens[2]
                machineInstructions.append(encodeRType(instrName, rsrc, rdest))

            addr += 1
    writeBinFile(machineInstructions)



