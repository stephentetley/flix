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

package flix.runtime.library;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * A wrapper class for String related functions that provides concrete, non-overloaded methods.
 */
public class RegexWrapper {

    // Create a matcher for pattern `patt` on the source string `input`.
    public static Matcher matcher(Pattern patt, String input) {
        final CharSequence src = input;
        return patt.matcher(src);
    }
}
