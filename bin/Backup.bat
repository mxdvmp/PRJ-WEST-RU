@echo off
SET BCS_JAVA_OPTS=%BCS_JAVA_OPTS% -Dbcs.logging.config=/com/arkona/log4j_backup.properties
SET BCS_JAVA_OPTS=%BCS_JAVA_OPTS% -Dbcs.logging.customconfig=/conf_local/log4j_backup.properties
@call "%~dp0\RunJava" --mainclass com.arkona.clients.Backup %*
