

# set allowedOpts to array of switch options, --switch
# allowedOpts=( --zero --one --two )

# set allowedOptArgs to array of option value args, --name value
# allowedOptArgs=( --name --foo )


# zeroOpt will be set (to --zero) if --zero supplied
# nameOpt will be set value if --name value is set
# all other args will be in args
declare -a args

while [ $# -ne 0 ]; do

  # check for -- which will dump everything remaining to args
  if [ "$1" == "--" ]; then
    shift
    break # while $#
  fi
  
  # check for match with allowedOpts
  let i=0
  for check in "${allowedOpts[@]}"; do
    if [ "$1" == "${check}" ]; then
      eval ${check//-/}Opt="$1"
      shift
      continue 2 # while $#
    fi
  done

  let i=0
  for check in "${allowedOptArgs[@]}"; do
    if [ "$1" == "${check}" ]; then
      eval ${check//-/}Opt="$2"
      shift 2
      continue 2 # while $#
    fi
    let i+=1
  done
  
  # pick up anything else as an arg
  args[${#args[*]}]=${1}
  shift

done

# anything leftover (after --) is an arg
while [ $# -ne 0 ]; do
  args[${#args[*]}]=${1}
  shift
done
