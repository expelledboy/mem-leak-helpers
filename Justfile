_default:
    @just --list --unsorted

# Start a remote daemon to collect memory usage
remote-start host:
    scp src/collect_mem_usage.sh {{host}}:/tmp
    ssh {{host}} screen -dmS mem_usage bash /tmp/collect_mem_usage.sh

# Peek at the output of the daemon
remote-peek host:
    ssh {{host}} screen -S mem_usage -X hardcopy /tmp/collect_mem_usage.txt
    ssh {{host}} cat /tmp/collect_mem_usage.txt

# Stop the remote daemon
remote-stop host:
    ssh {{host}} screen -S mem_usage -X quit

# Download the data from the remote host
remote-download host:
    rm -rf /tmp/{mem_usage.tar.gz,mem_usage}
    ssh {{host}} tar -czf /tmp/mem_usage.tar.gz -C /tmp mem_usage
    scp {{host}}:/tmp/mem_usage.tar.gz /tmp
    tar -xzf /tmp/mem_usage.tar.gz -C /tmp

# Purge any files used during the collection
remote-clean host:
    ssh {{host}} rm -rf \
        /tmp/collect_mem_usage.sh \
        /tmp/collect_mem_usage.txt \
        /tmp/mem_usage.tar.gz \
        /tmp/mem_usage

# Plot the data and open the graph
plot:
    ./src/plot_data.sh
    open mem_usage.png

_required-bins:
    #!/usr/bin/env bash
    (
        cat src/collect_mem_usage.sh | grep -Eo '\b[a-z]+\b' | xargs which | xargs -n 1 basename
        rg ssh Justfile | awk '{ print $3 }' | sort | uniq
    ) | sort | uniq