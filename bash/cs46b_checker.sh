#!/bin/bash
jarfilePath="$1"
graderFilePath="$2"
pkg="$3"
touch output.tsv
outputPath=$(find `pwd` -name output.tsv)

jarfile=$(echo "$jarfilePath" | rev | cut -d "/" -f1 | rev)
echo "Using $jarfile from $jarfilePath"

dirname=$(echo "$jarfile" | cut -d "." -f1)

tmpPath="/tmp/$dirname"
read -p "Confirm deletion: $tmpPath?" n readvar
rm -fr $tmpPath

echo "Creating $tmpPath"
mkdir $tmpPath

echo "Copying jar file: $jarfilePath to $tmpPath"
cp $jarfilePath $tmpPath


echo "Copying grader file: $graderFilePath to $tmpPath"
cp $graderFilePath $tmpPath

echo "Switching to $tmpPath"
cd $tmpPath

echo "Confirming current path: pwd="
pwd
read -p "Continue?" n readvar

echo "Extracting $jarfile"
ls $jarfile
jar xvf $jarfile

pkgpath="$tmpPath/$pkg"
echo "Confirm package path: $pkgpath"
read -p "Continue?" n readvar

echo "Removing class files from package"
rm $pkgpath/*.class
echo "Adding grader file to package"
graderfile=$(echo "$graderFilePath" | rev | cut -d "/" -f1 | rev)
cp $graderfile $pkgpath

echo "Listing files from package: $pkgpath"
ls $pkgpath
read -p "Continue?" n readvar

echo "Opening sources in sublime: $pkgpath"
subl $pkgpath &
subl_pid=$!
echo "Found subl pid: $subl_pid"

echo "Compiling..."
javac -cp . "$pkg/$graderfile"

graderclass=$(echo "$graderfile" | cut -d "." -f1)
read -p "Execute $pkg.$graderclass?" n readvar

echo "Executing..."
res=$(java -cp . "$pkg.$graderclass")

resMod=$(echo $res | sed 's/\n/, /g')
echo "Appending output to $outputPath"
echo "$resMod"
currdt=$(date +"%D %T")
echo "$dirname\t$currdt\t$resMod" >> $outputPath

#echo "Closing sources - pid=$subl_pid"
#kill "$subl_pid"