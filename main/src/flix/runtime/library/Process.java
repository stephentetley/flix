package flix.runtime.library;

import java.util.stream.Collectors;

// TODO: Finish implementation.
public class Process {

    private long pid;
    private long parent;
    private String command;
    private boolean isAlive;

    public Process(long pid, long parent, String command, boolean isAlive) {
        this.pid = pid;
        this.parent = parent;
        this.command = command;
        this.isAlive = isAlive;
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

    public static Process[] getProcesses() {
        var handles = ProcessHandle.allProcesses().collect(Collectors.toList());
        var result = new Process[handles.size()];
        for (var i = 0; i < result.length; i++) {
            var handle = handles.get(i);
            var pid = handle.pid();
            var parent = handle.parent().orElse(handle).pid();
            var command = handle.info().command().orElse("");
            var isAlive = handle.isAlive();
            result[i] = new Process(pid, parent, command, isAlive);
        }
        return result;
    }

}
