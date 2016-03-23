import fnmatch
import os
import subprocess

os.system('find . -name "*.pretty.go" -type f -delete')

f = open('test_results','w')
matches = []
for root, dirnames, filenames in os.walk('./TEST_PROGRAMS'):
        for filename in fnmatch.filter(filenames, '*.go'):
                    matches.append(os.path.join(root, filename))

for files in matches:
    f.write(files+'\n')
    cmd = "./src/goLite.native "+files
    #cmd = "./golitec typecheck "+files
    proc = subprocess.Popen(cmd,shell=True,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
    out, err = proc.communicate()
    f.write(out)
    f.write(err)
    f.write('\n')

f.close()
