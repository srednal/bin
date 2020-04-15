
lazy val scrubFiles = taskKey[Seq[File]]("List files (as show scrubFiles) to be cleaned via scrub")
scrubFiles := {
  Path.selectSubpaths(baseDirectory.value, { d => d.isDirectory && d.name == "target" }).map(_._1).toSeq
}
lazy val scrub = taskKey[Unit]("Clean the local ivy published modules, as well as associated cached modules")
scrub := {
  val files = scrubFiles.value
  val log = streams.value.log
  IO.delete(files)
  files foreach { f => log.info(s"Deleted $f") }
}
