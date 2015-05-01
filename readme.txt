--in order to use npm install with Visual Studio 2012, append –msvs_version=2012 (https://github.com/TooTallNate/node-gyp/issues/168)

e.g. npm install libxslt –msvs_version=2012


--Integrating Visual Studio with Git
http://www.codeproject.com/Articles/581907/IntegratingplusandplusUsingplusGithubplusinplusVis
you may need apply patch to visual studio (for me it worked, but Eric had to apply patch before integarting Git with VS.)
VS2012 update 2 - https://www.microsoft.com/en-us/download/details.aspx?id=39305



set path=%PATH%;"C:\Program Files (x86)\Java\jre7\bin";
