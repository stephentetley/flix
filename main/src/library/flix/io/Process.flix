// TODO: Should really be namespaced.

pub rel Process(pid: Int64, command: Str, alive: Bool, parent: Int64, user: Str)
pub rel File(name: Str, type: Str, size: Int64, readable: Bool, writable: Bool, executable: Bool, accessed: Int64, modified: Int64, created: Int64)

pub def getProcesses(): #{ Process | _ } =
    let ps = native method flix.runtime.library.Process.getProcesses() as Array[##flix.runtime.library.Process];
    let xs = Array.toList(ps);
    let f = (acc, p) -> {
        let pid = getPid(p);
        let parent = getParent(p);
        let command = getCommand(p);
        let alive = isAlive(p);
        let user = getUser(p);
        acc <+> Process(pid, command, alive, parent, user).
    };
    xs |> List.foldLeft(f, #{})

def getPid(p: ##flix.runtime.library.Process): Int64 =
    native method flix.runtime.library.Process.getPid(p) as Int64

def getParent(p: ##flix.runtime.library.Process): Int64 =
    native method flix.runtime.library.Process.getParent(p) as Int64

def isAlive(p: ##flix.runtime.library.Process): Bool =
    native method flix.runtime.library.Process.isAlive(p) as Bool

def getCommand(p: ##flix.runtime.library.Process): Str =
    native method flix.runtime.library.Process.getCommand(p) as Str

def getUser(p: ##flix.runtime.library.Process): Str =
    native method flix.runtime.library.Process.getUser(p) as Str

pub def listFiles(p: Path): #{File  | _} =
    match Path.getChildren(p) with {
        case Ok(Some(fs)) =>
            let f = (acc, file) -> {
                acc <+> getFileFact(file)
            };
            fs |> List.foldLeft(f, #{})
        case _ => #{}
    }

pub def getFileFact(file: Path): #{File | _ } =
    let name = Result.getWithDefault(Path.getName(file), "err");
    let type = if (Result.getWithDefault(Path.isDirectory(file), false)) "directory" else "file";
    let readable = Result.getWithDefault(Path.isReadable(file), false);
    let writable = Result.getWithDefault(Path.isWritable(file), false);
    let executable = Result.getWithDefault(Path.isExecutable(file), false);
    let size = getFileSize(file);
    let lastAccess = getLastAccessTime(file);
    let lastModified = getLastModified(file);
    let creationTime = getCreationTime(file);
    File(name, type,  size, readable, writable, executable,lastAccess, lastModified, creationTime).


pub def getFileSize(p: Path): Int64 =
    let Path(javaPath) = p;
    native method java.io.File.length(javaPath) as Int64

pub def getLastAccessTime(p: Path): Int64 =
    let Path(javaFile) = p;
    let javaPath = native method java.io.File.toPath(javaFile);
    let fileTime = native method java.nio.file.Files.getAttribute(javaPath, "lastAccessTime", (native method java.nio.file.LinkOption.values())) as ##java.nio.file.attribute.FileTime;
    native method java.nio.file.attribute.FileTime.toMillis(fileTime)

pub def getCreationTime(p: Path): Int64 =
    let Path(javaFile) = p;
    let javaPath = native method java.io.File.toPath(javaFile);
    let fileTime = native method java.nio.file.Files.getAttribute(javaPath, "creationTime", (native method java.nio.file.LinkOption.values())) as ##java.nio.file.attribute.FileTime;
    native method java.nio.file.attribute.FileTime.toMillis(fileTime)

pub def getLastModified(p: Path): Int64 =
    let Path(javaPath) = p;
    native method java.io.File.lastModified(javaPath) as Int64

// TODO: Symlink? created? extension? owner?
