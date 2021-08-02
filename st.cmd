#!../../bin/linux-x86_64/zaberNV

## You may have to change zaberNV to something else
## everywhere it appears in this file

< envPaths
epicsEnvSet("STREAM_PROTOCOL_PATH","$(ZABER)/protocol/:$(ALICAT)/protocol/")

cd "${TOP}"


## Register all support components
dbLoadDatabase "dbd/zaberNV.dbd"
zaberNV_registerRecordDeviceDriver pdbbase

drvAsynIPPortConfigure ("Zaber1","10.112.63.190:4001",0,0,0)
drvAsynIPPortConfigure( "alicat1", "10.112.63.190:4002 tcp", 0, 0, 0 )




## Load record instances
dbLoadRecords("db/ZaberAlicat.db")

#######################AUTOSAVE
epicsEnvSet("IOCNAME","bl4a-SE-ZaberNV")
epicsEnvSet("SAVE_DIR","/home/controls/var/$(IOCNAME)")

save_restoreSet_Debug(0)


save_restoreSet_status_prefix("BL4A:SE:ZABERNV")

set_requestfile_path("$(SAVE_DIR)")
set_savefile_path("$(SAVE_DIR)")

save_restoreSet_NumSeqFiles(3)
save_restoreSet_SeqPeriodInSeconds(600)
set_pass0_restoreFile("$(IOCNAME).sav")

##################################



cd "${TOP}/iocBoot/${IOC}"
iocInit


epicsThreadSleep(5)
makeAutosaveFileFromDbInfo("$(SAVE_DIR)/$(IOCNAME).req", "autosaveFields")
create_monitor_set("$(IOCNAME).req", 5)

