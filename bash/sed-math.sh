#http://stackoverflow.com/questions/14348432/how-to-find-replace-and-increment-a-matched-number-with-sed-awk

sed -r 's/([0-9]+)(.*)/echo "$((\1+1))\2"/ge'

#input: 
#1: step1
#1: step2

#result:
#2: step1
#2: step2

# http://superuser.com/questions/10201/how-can-i-prepend-a-line-number-and-tab-to-each-line-of-a-text-file
awk '{printf "%d: %s\n", NR, $0}'
# result
# 1: step1
# 2: step2
