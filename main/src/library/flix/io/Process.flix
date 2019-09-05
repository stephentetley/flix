// TODO: Should really be namespaced.

pub rel Process(pid: Int64, command: Str, alive: Bool, parent: Int64, user: Str)
pub rel File(name: Str, type: Str, size: Int64, readable: Bool, writable: Bool, executable: Bool, created: Int64, accessed: Int64, modified: Int64, parent: Str)

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

pub def getFileFact(p: Path): #{File | _ } =
    let fileName = Result.getWithDefault(Path.getName(p), "err");
    let fileType = if (Result.getWithDefault(Path.isFile(p), false)) "file" else "directory";
    let fileSize = getFileSize(p);
    let isReadable = Result.getWithDefault(Path.isReadable(p), false);
    let isWritable = Result.getWithDefault(Path.isWritable(p), false);
    let isExecutable = Result.getWithDefault(Path.isExecutable(p), false);
    let created = getCreationTime(p);
    let accessed = getAccessTime(p);
    let modified = getModifiedTime(p);
    let parent = getParentPath(p);
    File(fileName, fileType, fileSize, isReadable, isWritable, isExecutable, created, accessed, modified, parent).

pub def getFileSize(p: Path): Int64 =
    let Path(javaPath) = p;
    native method java.io.File.length(javaPath) as Int64

pub def getCreationTime(p: Path): Int64 =
    let Path(javaFile) = p;
    let javaPath = native method java.io.File.toPath(javaFile);
    let fileTime = native method java.nio.file.Files.getAttribute(javaPath, "creationTime", (native method java.nio.file.LinkOption.values())) as ##java.nio.file.attribute.FileTime;
    native method java.nio.file.attribute.FileTime.toMillis(fileTime)

pub def getAccessTime(p: Path): Int64 =
    let Path(javaFile) = p;
    let javaPath = native method java.io.File.toPath(javaFile);
    let fileTime = native method java.nio.file.Files.getAttribute(javaPath, "lastAccessTime", (native method java.nio.file.LinkOption.values())) as ##java.nio.file.attribute.FileTime;
    native method java.nio.file.attribute.FileTime.toMillis(fileTime)

pub def getModifiedTime(p: Path): Int64 =
    let Path(javaFile) = p;
    let javaPath = native method java.io.File.toPath(javaFile);
    let fileTime = native method java.nio.file.Files.getAttribute(javaPath, "lastModifiedTime", (native method java.nio.file.LinkOption.values())) as ##java.nio.file.attribute.FileTime;
    native method java.nio.file.attribute.FileTime.toMillis(fileTime)

pub def getParentPath(p: Path): Str =
    let Path(javaFile) = p;
    let parentFile = native method java.io.File.getParentFile(javaFile) as ##java.io.File;
    native method java.io.File.getCanonicalPath(parentFile) as Str

// TODO: Symlink? extension? owner?

// TODO: We should not use the prefix "get".

// TODO:Find a folder with two files that have inconsistent permissions?
