@echo off
rem   This batch file encapsulates a standard XEP call. 

set CP=C:\Program Files\RenderX\XEP\lib\xep.jar;C:\Program Files\RenderX\XEP\lib\saxon.jar;C:\Program Files\RenderX\XEP\lib\xt.jar

if x%OS%==xWindows_NT goto WINNT
"C:\Program Files\Java\jre6\bin\java" -classpath "%CP%" com.renderx.xep.XSLDriver "-DCONFIG=C:\Program Files\RenderX\XEP\xep.xml" %1 %2 %3 %4 %5 %6 %7 %8 %9
goto END

:WINNT
"C:\Program Files\Java\jre6\bin\java" -classpath "%CP%" com.renderx.xep.XSLDriver "-DCONFIG=C:\Program Files\RenderX\XEP\xep.xml" %*

:END


set CP=
