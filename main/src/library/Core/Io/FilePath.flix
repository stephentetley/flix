/*
 * Copyright 2020 Stephen Tetley
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

use Core/Io/IOError.IOError;

namespace Core/Io/FilePath {

    ///
    /// Represents a FilePath.
    ///
    pub opaque type FilePath = ##java.nio.file.Path

    ///
    /// Returns a new FilePath.
    ///
    pub def new(s: String): FilePath =
        import java.nio.file.Paths:get(String, Array[String]) as get1;
        FilePath(get1(s, [])) as & Pure

    ///
    /// Returns the FilePath `path` as a string.
    ///
    pub def toString(path: FilePath): String =
        import java.nio.file.Path.toString();
        let FilePath(path1) = path;
        path1.toString() as & Pure

    ///
    /// Returns the "family" of the operating system.
    /// Recognized families are "Unix" and "Windows", returns "Unknown" if the OS is
    /// not recognized.
    ///
    /// The interpretation of file paths by this library is system dependendant.
    /// For instance the path "/home/guest" is recognized as an absolute path on Unix
    /// systems, but is is considered the relative path "home/guest" on Windows.
    ///
    /// You may want to establish whether you are running on Unix or Windows before
    /// using certain functions in this library.
    ///
    pub def getOsFamily(): String =
        import get java.io.File:separatorChar as getSeparatorChar;
        match getSeparatorChar() {
            case '/'    => "Unix"
            case '\\'   => "Windows"
            case _      => "Unknown"
        } as & Pure

    ///
    /// Returns the normalization of `path`.
    ///
    /// The normalization of a path interprets the navigation elements e.g. current
    /// directory "." and parent parentory ".." a produces a canonical name.
    ///
    pub def normalize(path: FilePath): FilePath =
        import java.nio.file.Path.normalize();
        let FilePath(p1) = path;
        FilePath(p1.normalize()) as & Pure

    ///
    /// toAbsolutePath ...
    ///
    pub def toAbsolutePath(path: FilePath): Result[FilePath, IOError] & Impure =
        import java.nio.file.Path.toAbsolutePath();
        try {
            let FilePath(p1) = path;
            Ok(FilePath(p1.toAbsolutePath()))
        } catch {
            case _ : ##java.io.IOError => Err(IOError.Generic("I/O Error in Core/Io/FilePath.toAbsolutePath"))
        }

    pub def isAbsolute(path: FilePath): Bool =
        import java.nio.file.Path.isAbsolute();
        let FilePath(path1) = path;
        path1.isAbsolute() as & Pure

    pub def isRelative(path: FilePath): Bool  = !(isAbsolute(path))

    pub def getRoot(path: FilePath): Option[FilePath] & Impure =
        import java.nio.file.Path.getRoot();
        let FilePath(path1) = path;
        let root = path1.getRoot();
        if (isNull(root))
            None
        else
            Some(FilePath(root))

    pub def getParent(path: FilePath): Option[FilePath] & Impure =
        import java.nio.file.Path.getParent();
        let FilePath(path1) = path;
        let parent = path1.getParent();
        if (isNull(parent))
            None
        else
            Some(FilePath(parent))

    pub def getFileName(path: FilePath): Option[FilePath] & Impure =
        import java.nio.file.Path.getFileName();
        let FilePath(path1) = path;
        let name = path1.getFileName();
        if (isNull(name))
            None
        else
            Some(FilePath(name))

    pub def append(path: FilePath, other: FilePath): FilePath & Impure =
        import java.nio.file.Path.resolve(##java.nio.file.Path);
        let FilePath(path1) = path;
        let FilePath(other1) = other;
        FilePath(resolve(path1, other1)) |> normalize

    pub def getNameCount(path: FilePath): Int32 & Impure =
        import java.nio.file.Path.getNameCount();
        let FilePath(path1) = path;
        path1.getNameCount()

    pub def getNameAt(ix: Int32, path: FilePath): Option[FilePath] & Impure =
        try {
            import java.nio.file.Path.getName(Int32);
            let FilePath(path1) = path;
            path1.getName(ix) |> FilePath |> Some
        } catch {
            case _: ##java.lang.Exception => None
        }

    pub def getExtension(path: FilePath): Option[String] & Impure =
        match getFileName(path) |> Option.map(toString) {
            case None => None
            case Some(s) => match String.indexOfRight(s, ".") {
                case None => None
                case Some(ix) => Some(String.sliceRight(s, ix+1))
            }
        }


 }