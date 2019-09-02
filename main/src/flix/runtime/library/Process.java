package flix.runtime.library;

import java.time.Duration;
import java.time.Instant;
import java.util.stream.Collectors;

// TODO: Finish implementation.
public class Process {

    private long pid;
    private long parent;
    private String command;
    private String[] arguments;
    private boolean isAlive;
    private String user;
    private long start;
    private long cpu;

    public Process(long pid, long parent, String command, boolean isAlive, String user, String arguments[], long start, long cpu) {
        this.pid = pid;
        this.parent = parent;
        this.command = command;
        this.arguments = arguments;
        this.isAlive = isAlive;
        this.user = user;
        this.start = start;
        this.cpu = cpu;
    }

    public long getPid() {
        return pid;
    }


    public long getParent() {
        return parent;
    }

    public String getCommand() {
        return command;
    }

    public boolean isAlive() {
        return isAlive;
    }

    public String getUser() {
        return user;
    }

    public String[] getArguments() {
        return arguments;
    }

    public long getStart() {
        return start;
    }

    public long getCpu() {
        return cpu;
    }

    public static Process[] getProcesses() {
        var handles = ProcessHandle.allProcesses().collect(Collectors.toList());
        var result = new Process[handles.size()];
        for (var i = 0; i < result.length; i++) {
            var handle = handles.get(i);
            var pid = handle.pid();
            var parent = handle.parent().orElse(handle).pid();
            var command = handle.info().command().orElse("");
            var arguments = handle.info().arguments().orElse(new String[0]);
            var isAlive = handle.isAlive();
            var user = handle.info().user().orElse("");
            var start = handle.info().startInstant().orElse(Instant.now()).toEpochMilli();
            var cpu = handle.info().totalCpuDuration().orElse(Duration.ZERO).toNanos();
            result[i] = new Process(pid, parent, command, isAlive, user, arguments, start, cpu);
        }
        return result;
    }

}
