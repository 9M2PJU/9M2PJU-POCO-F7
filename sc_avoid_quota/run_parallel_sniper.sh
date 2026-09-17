#!/usr/bin/env bash
cd "/home/x/pocof7/sc_avoid_quota"

PYTHON_BIN="/home/x/pocof7/sc_avoid_quota/venv/bin/python"

echo "=== 4-Instance Sniper Running: $(date) ===" > sniper_combined.log

# Instance 1: Token #1 (Chrome) @ 1900ms
echo 1 | "$PYTHON_BIN" NScript.py > sniper_token1.log 2>&1 &
PID1=$!
sleep 0.2

# Instance 2: Token #2 (Firefox) @ 1400ms
echo 2 | "$PYTHON_BIN" NScript.py > sniper_token2.log 2>&1 &
PID2=$!
sleep 0.2

# Instance 3: Token #1 (Chrome) @ 300ms
echo 3 | "$PYTHON_BIN" NScript.py > sniper_token3.log 2>&1 &
PID3=$!
sleep 0.2

# Instance 4: Token #2 (Firefox) @ 150ms
echo 4 | "$PYTHON_BIN" NScript.py > sniper_token4.log 2>&1 &
PID4=$!

echo "Instances running: $PID1 $PID2 $PID3 $PID4" >> sniper_combined.log

wait $PID1 $PID2 $PID3 $PID4
echo "=== All Instances Finished: $(date) ===" >> sniper_combined.log
