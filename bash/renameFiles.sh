#Append -21jan16 to filename of all txt files, keeping txt as extension.
for f in *;do s=$f;s=${s/\.txt/\-21jan16\.txt};mv $f $s;echo $s; done
