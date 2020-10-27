import sys
from constants import opcodes
from constants import registers

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
    
def writeBinFile(machineInstrutions):
    with open("code.txt", 'w') as f:
        for instr in machineInstrutions:
            f.write(instr + '\n')

def encodeIType(instrName, imm, rdest):
    instr = opcodes[instrName]
    instr += registers[rdest]
    instr += format(int(imm), '08b')
    return instr

def encodeRType(instrName, rsrc, rdest):
    instr = opcodes[instrName][0]
    instr += registers[rdest]
    instr += opcodes[instrName][1]
    instr += registers[rsrc]
    return instr

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Must enter the file name as an argument.")
    
    file = sys.argv[1]
    asmInstructions = readASM(file) 
    machineInstrutions = []
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
                imm = tokens[1][:-1] #strip off the comma
                rdest = tokens[2]
                machineInstrutions.append(encodeIType(instrName, imm, rdest))
            else:
                rsrc = tokens[1][:-1] #strip off the comma
                rdest = tokens[2]
                machineInstrutions.append(encodeRType(instrName, rsrc, rdest))
    writeBinFile(machineInstrutions)
