{!  Unified reading from StdIn for different OS.

	Tested on:
	- Windows 7
	- Ubuntu 18.04

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
		1.0.0 2021-07-12 jrgdre, initial release
}
unit StdIn;
{$mode Delphi}

interface

uses
	classes;

type
	{!  Return values of the Read() function
		Also GetLastError() might provide more insights.
	}
	TStdInReadError = (
		sireNoError = 0  , // no error was detected
		sireNullHandle   , // app. doesn't have associated standard handles
		sireInvalidHandle, // could not GetHandle
		sireSourceErr    , // input is from none of the known sources (DISK|PIPE|CHAR)
		sireTimeOut      , // interactive input timed out
		sireReadError    , // an error during input reading occurred
		sireWriteError     // an error during ms writing occurred
	);

var
	{ Some parameters to tweek the ReadInteractive() behaviour.
	}
	TimeOutResolutionMS: QWord   = 50;   //< sleep duration between input checks
	ShowHint           : Boolean = True; //< show hints for interactive input
	Hint1: String = 'Start typing within %dms.';
	{$ifdef Linux}
		Hint2: String = 'Press CTRL+D when finished.';
	{$endif}
	{$ifdef Windows}
		Hint2: String = 'Press CTRL+Z when finished.';
	{$endif}

{!  Append `memory` with the values read from StdIn.

	Works for following use cases:
	1. `prg < file`
	2. `(type, cat) file | prg`
	3. `prg`

	In the first two cases it is assumed, that all the input is in the file.
	The file is read with blocking calls, until the end of the file is reached.

	In the third case the function waits for the user to input the first char.
	If `timeOut` is reached before that, the procedure exits.
	After the first char is read, the routine waits indefinitely for more chars
	to to be entered, until it reads the EOF signal.

	The default value of `0` for `timeOut` makes the procedure wait indefinitely
	also for the first char.

	`timeOut` as a fixed resolution of 50ms.

	@returns TStdInReadError
}
function Read(
	  var ms     : TMemoryStream; //!< target of read operation
	const timeOut: NativeUInt = 0 //!< timeout for first key input (50ms res.)
): TStdInReadError; overload;

implementation

uses
	{$ifdef Linux}
		StdIn_Linux
	{$endif}
	{$ifdef Windows}
		StdIn_Windows
	{$endif}
;

function Read(
	  var ms     : TMemoryStream;
	const timeOut: NativeUInt = 0
): TStdInReadError; overload;
begin
	{$ifdef Linux}
		Result := Linux_read_StdIn(ms, timeOut);
	{$endif}
	{$ifdef Windows}
		Result := Windows_Read_StdIn(ms, timeOut);
	{$endif}
end;

end.
