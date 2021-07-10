{!  Unified reading from StdIn for different OS, demo application.

    Works for following use cases:
    1. `prg < file`
    2. `(type, cat) file | prg`
    3. `prg`

    In the first two cases it is assumed, that all the input is in the file.
    The file is read with blocking calls, until the end of the file is reached.

    In the third case the function waits for the user to input the first char.
    If `timeOut` (set to 5s) is reached before that, the procedure exits.
    After the first char is read, the routine waits indefinitely for more chars
    to to be entered, until it reads the EOF signal.

    -> This might not work, if run under debugger control. Tests show that some
       debuggers (e.g. gdb) seem to send at least one char to stdin.

    @copyright
        (c)2021 Medical Data Solutions GmbH, www.medaso.de

    @license
        MIT:
            Permission is hereby granted, free of charge, to any person
            obtaining a copy of this software and associated documentation files
            (the "Software"), to deal in the Software without restriction,
            including without limitation the rights to use, copy, modify, merge,
            publish, distribute, sublicense, and/or sell copies of the Software,
            and to permit persons to whom the Software is furnished to do so,
            subject to the following conditions:

            The above copyright notice and this permission notice shall be
            included in all copies or substantial portions of the Software.

    @author
        jrgdre: J.Drechsler, Medical Data Solutions GmbH

    @version
        1.0.0 2021-07-08 jrgdre, initial release (win64 working)
}
program stdin_demo;
{$mode Delphi}

uses
    StdIn,
    classes;

var
    es: String;
    ms: TMemoryStream;
    re: TStdInReadError;
    ss: TStringStream;
begin
    ss := TStringStream.Create;
    ms := ss as TMemoryStream;
    try
        re := StdIn.Read(ms, 5000);
        es := '';
        case re of
            sireNullHandle:
                es := 'app. doesn'+#39+'t have associated standard handles';
            sireInvalidHandle:
                es := 'could not GetHandle';
            sireSourceErr:
                es := 'input is from none of the known sources (DISK|PIPE|CHAR)';
            sireTimeOut:
                es := 'interactive input timed out';
            sireReadError:
                es := 'an error during input reading occurred';
            sireWriteError:
                es := 'an error during ms writing occurred';
            else
                WriteLn(ss.DataString);
        end;
        if (re <> sireNoError) then begin
            WriteLn(stdErr, es);
            ExitCode := -1;
        end;
    finally
        ss.Free;
    end;
end.
