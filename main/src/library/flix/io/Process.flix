// TODO: Should really be namespaced.

pub rel Process(pid: Int64, command: Str, alive: Bool, parent: Int64, user: Str)
pub rel File(name: Str, type: Str)

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
                let name = Result.getWithDefault(Path.getName(file), "err");
                acc <+> File(name, "file").
            };
            fs |> List.foldLeft(f, #{})
        case _ => #{}
    }
