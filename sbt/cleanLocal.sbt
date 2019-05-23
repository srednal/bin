// `show cleanLocalFiles` - list which files will be deleted by cleanLocal
lazy val cleanLocalFiles = taskKey[Seq[File]]("List files (as show cleanLocalFiles) to be cleaned via cleanLocal")
cleanLocalFiles := {
  val ivyDir = ivyPaths.value.ivyHome getOrElse (Path.userHome / ".ivy2")
  val ivyLocalDir = ivyDir / "local"
  val ivyCacheDir = ivyDir / "cache"

  // look at what local/organization/module we have
  val ivyLocalModules = (ivyLocalDir * "*" * "*").get map { f => f.getParentFile.getName -> f.getName }

  // delete from cache any modules that are in local
  val cache = ivyLocalModules.map { case (org, module) => ivyCacheDir / org / module }
  // and of course delete local
  if (ivyLocalDir.exists) { ivyLocalDir +: cache } else cache
}

lazy val cleanLocal = taskKey[Unit]("Clean the local ivy published modules, as well as associated cached modules")
cleanLocal := {
  val files = cleanLocalFiles.value
  val log = streams.value.log
  IO.delete(files)
  files foreach { f => log.info(s"Deleted $f") }
}
