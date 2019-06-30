""" cvs2dat
    (c) 2009 - Michael 'Cruzer' Hohl

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
"""
import os, os.path, sys

class DATParser():
    def __init__(self, file):
        """ Parses a DAT file. """
        self.filename = file
        self._datfobj = open(file)
        self._dat = list()
        self._dat.append({})

        # Parses the whole file and save it in self.dat
        # line_num saves the actuall line in the file
        i = 0; line_num = 0
        for line in self._datfobj:
            line_num += 1
            if line.startswith("---"):
                i += 1; self._dat.append({})
            elif line.count("=")==1:
                entry = line.split("=")
                if len(entry)==2:
                    self._dat[i].update({entry[0]:entry[1]})
                else:
                    raise InvalidDATException("There's an error in line {0} in dat-file {1}!".format(line_num, self.filename))
                

    def read(self, obj, option):
        """ Return the value to the option. """
        for entry in self._dat:
            if "obj" in entry and entry["obj"]==obj:
                if option in entry:
                    return entry[option]
                else:
                    raise InvalidDATOptionException("There's no {0} entry in {1}.".format(option, self.filename))
                

    def object(self):
        """ Returns a list of all objects. """
        obj_list = list()
        for entry in self._dat:
            if "obj" in entry:
                obj_list.append(entry["obj"])
        return obj_list

    def count(self, option, value):
        """ Counts all objects with the given option==value. """
        obj = 0
        for entry in self._dat:
            if option in entry and entry[option]==value+'\n':
                obj += 1
        return obj

class InvalidDATException(IOError):
    pass

class InvalidDATOptionException(IOError):
    pass

def main():
    res = 0; com = 0; ind = 0; mon = 0; tow = 0
    for datfile in os.listdir("."):
        if datfile.endswith(".dat"):
            dat = DATParser(datfile)
            res += dat.count("type", "res")
            com += dat.count("type", "com")
            ind += dat.count("type", "ind")
            mon += dat.count("type", "mon")
    print("Buildings:")
    print(" RES: {0:>3}".format(res))
    print(" COM: {0:>3}".format(com))
    print(" IND: {0:>3}".format(ind))
    print(" MON: {0:>3}".format(mon))
    print("")
    


if __name__ == "__main__":
    main()
