# Memory Leaks

> Utilities to assist you finding processes that are leaking memory on a running system

### Requirements

The scripts in this project uses the following versions of the tools, installed locally:

```
GNU bash, version 5.2.15(1)-release (aarch64-apple-darwin22.3.0)
GNU Awk 5.2.1, API 3.2
gnuplot 5.4 patchlevel 6
just 1.13.0
```

If there is any problem with the scripts, please check the versions of the tools you are using.

```bash {cmd}
bash --version | grep 'GNU bash'
awk --version | grep 'GNU Awk'
gnuplot --version
just --version
```

For you convenience, you can start a `nix-shell`

```
~/repos/mem-leak-helpers on master!
$ nix-shell

[nix-shell:~/repos/expelledboy/mem-leak-helpers]$ just
Available recipes:
    remote-start host    # Start a remote daemon to collect memory usage
    remote-peek host     # Peek at the output of the daemon
    remote-stop host     # Stop the remote daemon
    remote-download host # Download the data from the remote host
    remote-clean host    # Purge any files used during the collection
    plot                 # Plot the data and open the graph
```

On the remote host, the following tools are required:
```
bash
cat
date
echo
getopts
grep
mkdir
ps
read
rm
sample
screen
sleep
tar
true
```


If this list is outdated, run the following to get the list of required tools:

```bash {cmd}
just _required-bins
```

### Usage

From your local machine, run the following commands:

```bash
export host=host_name_or_ip_address

just remote-start ${host} # Start collecting data

just remote-download ${host} # At anytime pull the data
just plot # ... and plot it

just remote-stop ${host} # Stop collecting data
just remote-clean ${host} # Keep your sysadmin happy :)

just remote-peek ${host} # If you want to peek at the daemons output
```

### Notes

- So long as you don't delete the data directory on the remote host, you can stop and start the data collection at any time.
- If your host is crashing and clearing the `/tmp` directory, please look through the `./src` and the `Justfile` for how to change the data directory of the daemon.