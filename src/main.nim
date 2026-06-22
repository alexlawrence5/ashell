import os, strutils, osproc, sequtils, streams

discard execShellCmd("clear")

# configurable settings
var inimsg = "Welcome to the AShell!"
var faimsg = "Error occured."
var cdfaimsg = "Invalid directory."
var elsemsg = "Command not found."

# let strings
let emptmsg = "A command should be full, not empty."

# dead line, dont touch this if u dont know what ur doing
proc runPipeline(cmdLine: string) =
  let parts = cmdLine.split("|").mapIt(it.strip())

  var inputData = ""

  for i, cmd in parts:
    let args = cmd.splitWhitespace()
    if args.len == 0:
      continue

    let program = args[0]
    let params = if args.len > 1: args[1..^1] else: @[]
    
    if program == "echo":
      inputData = params.join(" ")
      continue

    try:
        let p = startProcess(program,
                            args = params,
                            options = {poUsePath, poStdErrToStdOut})

        if inputData.len > 0:
            write(p.inputStream, inputData)
            p.inputStream.close()

        inputData = p.outputStream.readAll()
        discard p.waitForExit()

    except OSError:
        echo elsemsg
        return

  echo inputData

# and yes, including THIS!
proc main() =
  echo inimsg # register inimsg

  setControlCHook(proc () {.noconv.} =
    echo "\n^C caught (Ctrl+C). Use 'exit' to quit cleanly."
  )

  while true:
    stdout.write("$ ")
    let input = readLine(stdin).strip()

    if input == "":
      echo emptmsg
      continue

    if input == "exit":
      break

    if input == "clear":
      echo "\x1Bc"
      continue

    if input == "pwd":
      echo getCurrentDir()
      continue

    if input == "yo which distro am i using gng?":
      let res = execProcess(". /etc/os-release && echo $PRETTY_NAME")
      echo res.strip()
      continue

    if input.startsWith("cd "):
      let path = input[3..^1].strip()
      try:
        setCurrentDir(path)
      except:
        echo cdfaimsg
      continue

    runPipeline(input)

main()
