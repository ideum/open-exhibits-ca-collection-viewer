# -*- coding: utf-8 -*-
"""
A script which builds CML dial combination strings (for the CA version of
the Collection Viewer), by polling the CA database for all existing dial values.

Author: Rob Herbertson 7/24/2014
Note: Developed using Python 2.7.6
"""
from pyamf.remoting import RemotingError
from pyamf.remoting.client import RemotingService
import xml.etree.ElementTree as ET
import os
import re
import time
import sys

# CML backup file location
backupDir = "_CVCFU_CML_BACKUP"

# serves as a globally accessible Dock CML tag counter variable
dockCnt = 0
def getDockCnt(): # dockCnt getter
    global dockCnt
    return dockCnt
def incrDockCnt(): # dockCnt incrementer
    global dockCnt
    dockCnt += 1 # no ++ operator in python :(
    return dockCnt

def buildCombs():
    '''
    dial1CombStr = buildCombSet(1) # dial 1 combinations
    print "Dial 1 Combination(s):\n", dial1CombStr, "\n"
    dial2CombStr = buildCombSet(2) # dial 2 combinations
    print "Dial 2 Combination(s):\n", dial2CombStr, "\n"
    dial3CombStr = buildCombSet(3) # dial 3 combinations
    print "Dial 3 Combination(s):\n", dial3CombStr, "\n"
    return [dial1CombStr, dial2CombStr, dial3CombStr]
    '''
    return [buildCombSet(1), buildCombSet(2), buildCombSet(3)]
    
def buildCombSet(dialNumber):
    if dialNumber < 0 or dialNumber > 3:
        return

    dialSet = set()
    y = dialNumber - 2 # 'first' value index within tuple
    z = dialNumber - 1 # 'second' value index with tuple

    # use the same tuple index for dial1, then discard right half later
    if dialNumber == 1:
        y = z

    # build a set of pairs pulled from the list of triples
    # for dial 2, we use the first and second members, for dial 3 we
    # use the second and third members
    for x in range(0, len(tripleList)):
        dialSet.add((tripleList[x][y], tripleList[x][z]))

    return buildCombStr(dialSet, dialNumber)

def buildCombStr(dialSet, dialNumber):
    dialSetLen = len(dialSet) # the number of unique combinations
    dialCombStr = ""

    dialSet = sorted(dialSet)
    
    if dialSetLen == 1:
        member = dialSet.pop()
        if dialNumber == 1:
            return member[0]
        else:
            return member[0] + ":" + member[1]

    else:
        if dialNumber == 1:
             for e in dialSet:
                dialCombStr += e[0] + ",,\n"
        else:
            for e in dialSet:
                dialCombStr += e[0] + ":" + e[1] + ",,\n"
        return dialCombStr.rstrip(',\n')

'''
Takes the JSON output from the get_all_dials method in the CA AMFPHP script and
returns a list of 3-Tuples (triples). Each 3-Tuple represents a single object
in the CA database. Iff Dial 1 is empty, we skip that "object".
'''
def buildDialTupleList(dbDialResults):
    tripleList = []

    for x in range(0, len(dbDialResults)):
        if len(dbDialResults[x]['dial1']) < 1:
            continue
        tripleList.append(dialResultToTriple(dbDialResults[x]))

    return tripleList

# determine if the specified CML file is a wall or table version
def checkCMLVersion():
    dockTypeMsg = "Collection Viewer Type: "

    for child in root.iter('Dock'): # count the number of Dock tags
        incrDockCnt()
        #print child.tag, child.attrib, '\n'

    # check the count...
    if getDockCnt() == 1:
        dockTypeMsg += "WALL (1 Dock)"
    elif getDockCnt() == 2:
        dockTypeMsg += "TABLE (2 Docks)"
    else:
        print("Error: found 0 or more than 2 Dock tag(s) in specified CML file!\n"
        "Press ENTER to exit.")
        exit(raw_input())

    print dockTypeMsg # notify user of the count result

def dialResultToTriple(result):    
    '''
    # more robust version which checks char encoding, slow if db is large
    import json
    data = json.loads(json.dumps(result))
    return (data['dial1'], data['dial2'], data['dial3'])
    '''
    
    # fast version with no char encoding checks or conversions
    return (result['dial1'], result['dial2'], result['dial3'])
    
# parse the CML file into an ElementTree
def parseCML(filePath):
    try:
        return ET.parse(filePath)
    except IOError:
        print("Error opening, or creating backup for: " + filePath + "\n\n"
            "Press ENTER to exit.")
        exit(raw_input())
    
# read the dial combinations from the CA db as a JSON array
def getDialValuesFromDB():
    gateway = RemotingService("http://localhost/providence/amfphp-2.1/Amfphp/")
    service = gateway.getService("ObjectSearchTest.getalldials")
    return service(None)

def printDialCombsInTree():
    # recall a dock has exactly three dials so a CML
    # with two Dock tags will have 6 dials in total
    if getDockCnt() == 2:
        print "\n(TOP DOCK)"

    for child in root.iter('Dial'):
        dial = child.get('id')
        text = child.get('text')
        print dial + ":\n", text, "\n"

        # a little dirty, this will break if dial-ids are changed in CML
        if dial == "dial-3" and getDockCnt() == 2:
            print "(BOTTOM DOCK)"

def setCombsInET(combList):
    index = 0
    for child in root.iter('Dial'):
        if index % 3 == 0: # reset or intialize combList iterator
            combIter = iter(combList)

        child.set('text', combIter.next())
        index += 1

def writeBackup(filePath):
    namePartMatchObj = re.search("(\w+\..+)$", filePath)
    backupFile = time.strftime("%m-%d-%Y--%H-%M-%S--") + namePartMatchObj.group()
    
    if not os.path.exists(backupDir):
        os.makedirs(backupDir)
    tree.write(backupDir + "/" + backupFile)
    print "Wrote backup: " + backupFile
    
## END FUNCTION DECLARATIONS ##

## below is the pseudo-equivalent of this script's main() function ##
if len(sys.argv) < 2:
    print("Invalid argument(s). Usage examples:\n\n"
    "Normal Mode:\n"
    "/> CVCFU.py pathToCMLFile\n\n"
    "Verbose Mode (outputs current and new dial combinations):\n"
    "/> CVCFU.py pathToCMLFile -v\n\n"
    "If there is any whitespace in the filepath, enclose it in double quotes.\n\n"
    "WARNING:\nRunning CVCFU in VERBOSE mode in a shell which does not support "
    "unicode character encoding can cause CVCFU to crash. In this case, either "
    "use a different shell, or omit the -v argument.\n\n"
    "Press ENTER to exit.")
    exit(raw_input())

verbose = False
if len(sys.argv) > 2 and sys.argv[2] == "-v":
    verbose = True

print "Maxwell Museum Collection Viewer CML File Updater (MM)CVCFU v0.1\n"
filePath = sys.argv[1]
tree = parseCML(filePath)
root = tree.getroot()
writeBackup(filePath)
checkCMLVersion()
print "Loading CML complete.\n"

if verbose:
    print "Current Dial Combination(s):"
    printDialCombsInTree()
    sys.stdout.flush()

# get list of each object's dial values, then build the new combinations
print "Reading dial values from CA's DB, then building combinations, please wait...\n"
try:
    dialValues = getDialValuesFromDB()
except RemotingError:
    print("Unable to connect to database.\nDid you run 'Start Collective "
        "Access.exe' and does it show Apache and MySQL are running?\n\n"
        "Press ENTER to exit.")
    exit(raw_input())

tripleList = buildDialTupleList(dialValues)
combsList = buildCombs()
setCombsInET(buildCombs())

if verbose:
    print "Updated Dial Combination(s):"
    printDialCombsInTree()

tree.write(filePath)
print "Update completed successfully.\n\nPress ENTER to exit."
sys.stdout.flush()
exit(raw_input())
