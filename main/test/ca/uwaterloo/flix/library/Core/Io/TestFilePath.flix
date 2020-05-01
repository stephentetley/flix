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

use Core/Io/FilePath.{FilePath, getOsFamily};


namespace TestFilePath {

////////////////////////////////////////////////////////////////////////////////
// new                                                                        //
////////////////////////////////////////////////////////////////////////////////

@test
def new01(): FilePath =
    Core/Io/FilePath.new("C:\cygwin64\home\stephen\.bashrc")

@test
def new02(): FilePath =
    Core/Io/FilePath.new("/home/stephen/.bashrc")

@test
def new03(): FilePath =
    Core/Io/FilePath.new(".")

////////////////////////////////////////////////////////////////////////////////
// getOsFamily                                                                //
////////////////////////////////////////////////////////////////////////////////

@test
def getOsFamily01(): Bool =
    let os = Core/Io/FilePath.getOsFamily();
    os == "Unix" || os == "Windows" || os == "Unknown"



////////////////////////////////////////////////////////////////////////////////
// toString                                                                   //
////////////////////////////////////////////////////////////////////////////////

@test
def toString01(): Bool =
    if (getOsFamily() != "Windows")
        true
    else {
        let p = Core/Io/FilePath.new("C:\cygwin64\home\stephen\.bashrc");
        Core/Io/FilePath.toString(p) == "C:\cygwin64\home\stephen\.bashrc"
    }

@test
def toString02(): Bool =
    if (getOsFamily() != "Unix")
        true
    else {
        let p = Core/Io/FilePath.new("/home/stephen/.bashrc");
        Core/Io/FilePath.toString(p) == "/home/stephen/.bashrc"
    }

@test
def toString03(): Bool =
    let p = Core/Io/FilePath.new(".");
    Core/Io/FilePath.toString(p) == "."

////////////////////////////////////////////////////////////////////////////////
// isAbsolute                                                                 //
////////////////////////////////////////////////////////////////////////////////

@test
def isAbsolute01(): Bool =
    use Core/Io/FilePath.isAbsolute;
    if (getOsFamily() != "Windows")
        true
    else {
        let s = "C:\cygwin64\home\stephen\.bashrc";
        Core/Io/FilePath.new(s).isAbsolute() == true
    }

@test
def isAbsolute02(): Bool =
    use Core/Io/FilePath.isAbsolute;
    if (getOsFamily() != "Unix")
        true
    else {
        let s = "/home/stephen/.bashrc";
        Core/Io/FilePath.new(s).isAbsolute() == true
    }

@test
def isAbsolute03(): Bool =
    use Core/Io/FilePath.isAbsolute;
    Core/Io/FilePath.new(".").isAbsolute() == false


}