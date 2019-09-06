package flix.runtime.library;

import java.time.Duration;
import java.time.Instant;
import java.util.stream.Collectors;

// TODO: Finish implementation.
public class Process {

    private long pid;
    private long parent;
    private String command;
    private boolean isAlive;
    private String user;
    private long created;
    private long cpu;

    public Process(long pid, long parent, String command, boolean isAlive, String user, long created, long cpu) {
        this.pid = pid;
        this.parent = parent;
        this.command = command;
        this.isAlive = isAlive;
        this.user = user;
        this.created = created;
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

    public long getCreated() {
        return created;
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
            var args = handle.info().arguments().orElse(new String[0]);
            var isAlive = handle.isAlive();
            var user = handle.info().user().orElse("");
            var start = handle.info().startInstant().orElse(Instant.now()).toEpochMilli();
            var cpu = handle.info().totalCpuDuration().orElse(Duration.ZERO).toNanos();
            result[i] = new Process(pid, parent, command, isAlive, user, start, cpu);
        }
        return result;
    }

}
