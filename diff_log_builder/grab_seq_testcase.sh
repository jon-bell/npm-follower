#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
seq=$1

psql -p 5431 -h 127.0.0.1 npm_data -c "SELECT raw_json FROM change_log where seq = $seq;" -t -A -o $SCRIPT_DIR/resources/test_deserialize_change/input/seq_$seq.json.tmp
python -m json.tool $SCRIPT_DIR/resources/test_deserialize_change/input/seq_$seq.json.tmp > $SCRIPT_DIR/resources/test_deserialize_change/input/seq_$seq.json
rm $SCRIPT_DIR/resources/test_deserialize_change/input/seq_$seq.json.tmp
