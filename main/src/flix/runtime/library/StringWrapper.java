/*
 * Copyright 2019 Stephen Tetley
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

import java.lang.StringBuilder;

/**
 * A wrapper class for String related functions that provides concrete, non-overloaded methods.
 */
public class StringWrapper {

    // Append the contents of the StringBulder `sb2` to StringBuilder `sb1`.
    public static void appendStringBuilder (StringBuilder sb1, StringBuilder sb2) {
        final CharSequence cs2 = sb2;
        sb1.append(cs2);
        return;
    }

    // Replace all occurrences of `target` with the string `replacement` in the source string `source`.
    public static String replace(String target, String replacement, String source) {
        final CharSequence t = target;
        final CharSequence r = replacement;
        return source.replace(t, r);
    }

}
