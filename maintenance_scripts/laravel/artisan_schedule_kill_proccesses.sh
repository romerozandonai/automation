#!/bin/bash



log_date=$(date +'%Y-%m-%d_%H-%M-%S')
LOG="/var/log/artisan_schedule_kill_proccesses.log"

NUM_PROCS=$(ps aux | grep artisan | wc -l)

if [[ $NUM_PROCS -ge 300  ]]; then
    pkill -f "php /var/www/webroot/ROOT/artisan schedule:run" && pkill -f "/bin/sh -c php /var/www/webroot/ROOT/artisan schedule:run >> /dev/null 2>&1"
    echo "[$log_date] Mortos $NUM_PROCS processos." | tee -a "$LOG"
else
    echo "[$log_date] Nenhum processo morto - $NUM_PROCS processos." | tee -a "$LOG"
fi