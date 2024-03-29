# Setup the files
clear
task export > Temp.json
rm  -f *csv
in2csv Temp.json > Data.csv
#csvcut -c id,due,description Data.csv > Temp.csv
csvcut -c id,due,description,tags/0  Data.csv > Temp.csv

apts=/home/zaki/.calcurse/apts
todo=/home/zaki/.calcurse/todo


# Sed
sed -i  's/^0.*//'  Temp.csv
sed -i  '/^$/d'  Temp.csv
sed -i 's/^\w*,//' Temp.csv
sed -i 's/\w\w+\w\w:00//' Temp.csv
sed -i 's/:,/,/' Temp.csv
cat Temp.csv > App.csv
cat Temp.csv > Task.csv
sed -i '/recurring/d' Temp.csv
sed -i '/2019/!d' App.csv
sed -i '/2019/d' Task.csv
#tail -n +2 "Task.csv" > Temp.csv
#cat Temp.csv > Task.csv
# Print shit to the files
# Clear the file
cat $apts > Backup
touch Calc
Calcurse=Calc
grep '\[1\]' $apts > $Calcurse
grep '@' $apts > $Calcurse
> $apts
cat $apts

IFS=','
INPUT_FILE='App.csv'
while read A B C 
do
	Date=$(echo $A | sed 's/T.*//')
	Time=$(echo $A | sed 's/.*T//')
	Hour=$(echo $Time | sed 's/:.*//' | sed 's/^0//')
	Hour=$(($Hour-4))
	Minute=$(echo $Time | sed 's/..://')

	Month=$(echo $Date | sed 's/\w\w\w\w-//' | sed 's/-\w\w//')
	Day=$(echo $Date | sed 's/.*-//' )
	Day=$(($Day+1))
	Year=$(echo $Date | sed 's/-.*//')

	if [ $Hour -eq 0 ]
	then
		echo "$Month/$(($Day-1))/$Year [2] $B" >> $apts
	else
		echo "$Month/$Day/$Year @ $Hour:$Minute -> $Month/$Day/$Year @ $Hour:$Minute|$B" >> $apts
	fi
done  < $INPUT_FILE

cat $Calcurse >> $apts
tmp=$(mktemp)
sort $apts | uniq > $tmp
cat $tmp > $apts

> $todo
IFS=','
INPUT_FILE='Task.csv'
if [ ! -s $INPUT_FILE ] 
then
	while read A B C 
	do
		echo  "[1] $B"  >> $todo
	done < $INPUT_FILE
	tmp=$(mktemp)
	sort $sort | uniq > $tmp
	cat $tmp > $sort
fi

#rm *csv
#rm $Calcurse
#rm Backup
#rm *json
