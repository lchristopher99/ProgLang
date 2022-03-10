#!/bin/bash

count=0
pass=0
fail=0
context=0

# run individual test
if [ "$1" == '-i' ]
then
  if [ "$2" != '' ]
  then
    FILE_IN=$2
  fi

  for FILE_OUT in *
  do
    # make sure there is a corresponding output file for provided input file
    if ([ ${FILE_OUT##*.} == 'out' ] || [ ${FILE_OUT##*.} == 'correct' ]) && ([ ${FILE_IN%.*} == ${FILE_OUT%.*} ])
    then
      count=1
      printf "Running Test $FILE_IN | "

      # EDIT THIS LINE FOR FUTURE LABS TO POINT TO EXECUTABLE
      # run results of input file against compare file
      if ../Part_1_Starting_Point/tips_lex $FILE_IN | diff - $FILE_OUT
      then
        printf "\xe2\x9c\x85\n"
        pass=$((pass += 1))
      else
        printf "\n$FILE_IN --> $FILE_OUT \xE2\x9D\x8C\n\n"
        fail=$((fail += 1))
      fi
    fi
  done
else
  # for each file in test cases directory
  # find input data, with proper extension
  for FILE_IN in *
  do
    if [ ${FILE_IN##*.} == 'in' ] || [ ${FILE_IN##*.} == 'csv' ]
    then
      # for each file in test cases directory
      # find a matching compare file, with proper extension
      for FILE_OUT in *
      do
        if ([ ${FILE_OUT##*.} == 'out' ] || [ ${FILE_OUT##*.} == 'correct' ]) && ([ ${FILE_IN%.*} == ${FILE_OUT%.*} ])
        then
          printf "Running Test $((count += 1)) | "
          # apply command line arguments if present
          if [ "$1" == '-g' ]
          then
            if [ "$2" != '' ]
            then
              context=$2
            fi

            # EDIT THIS LINE FOR FUTURE LABS TO POINT TO EXECUTABLE
            # run results of input file against grep to find errors in file, with up to n lines of context
            if ../Part_1_Starting_Point/tips_lex $FILE_IN | grep -B $context -m 1 ERROR
            then
              printf "\n$FILE_IN --> $FILE_OUT \xE2\x9D\x8C\n\n"
              fail=$((fail += 1))
            else
              printf "\xe2\x9c\x85\n"
              pass=$((pass += 1))
            fi
          else
            # EDIT THIS LINE FOR FUTURE LABS TO POINT TO EXECUTABLE
            # run results of input file against compare file
            if ../Part_1_Starting_Point/tips_lex $FILE_IN | diff - $FILE_OUT
            then
              printf "\xe2\x9c\x85\n"
              pass=$((pass += 1))
            else
              printf "\n$FILE_IN --> $FILE_OUT \xE2\x9D\x8C\n\n"
              fail=$((fail += 1))
            fi
          fi
        fi
      done
    fi
  done
fi

echo "--------------"
printf "\xf0\x9f\x91\x89 Total: $count\n"
printf "\xe2\x9c\x85 Pass:  $pass\n"
printf "\xE2\x9D\x8C Fail:  $fail\n"
echo "--------------"

if [ $count == $pass ]
then
  printf "ALL PASS \xe2\x9c\x85\n"
elif [ $count == $fail ]
then
  printf "ALL FAIL \xE2\x9D\x8C\n"
fi
