/*
* dvbapi  - softcam dvbapi plugin
*
*
* This Program is free software; you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation; either version 2, or (at your option)
* any later version.
*
* This Program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with XBMC; see the file COPYING. If not, write to
* the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
* http://www.gnu.org/copyleft/gpl.html
*
*/

#ifndef ___DVBAPI_H
#define ___DVBAPI_H


#include <getopt.h>
#include <vdr/plugin.h>
#include "SCDVBDevice.h"




class DVBAPI : public cPlugin
{

public:
  DVBAPI(void);
  virtual ~DVBAPI();
  virtual const char *Version(void) { return "0.0.1"; }
  virtual const char *Description(void) { return  "DVBAPI type SOFTCAM"; }
  virtual const char *CommandLineHelp(void);
  virtual bool ProcessArgs(int argc, char *argv[]);
  virtual bool Initialize(void);
  virtual bool Start(void);
  virtual void Stop(void);
  virtual void Housekeeping(void);
  virtual void MainThreadHook(void);
  virtual cString Active(void);
  virtual time_t WakeupTime(void);
  virtual const char *MainMenuEntry(void) { return NULL; }
  virtual cOsdObject *MainMenuAction(void) { return NULL; }
  virtual cMenuSetupPage *SetupMenu(void);
  virtual bool SetupParse(const char *Name, const char *Value);
  virtual bool Service(const char *Id, void *Data = NULL);
  virtual const char **SVDRPHelpPages(void);
  virtual cString SVDRPCommand(const char *Command, const char *Option, int &ReplyCode);
};

#endif // ___DVBAPI_H
