# Translating the Open EdX Platform

## Getting Started with Transifex
Open Edx uses Transifex, an open source translation platform, to power the translation of edX software into different languages.

### Sign up for an Account
Register an account on [Transifex](www.transifex.com/sigup/).

### Join a Translation Team
1. Visit [edx-platform project](https://www.transifex.com/open-edx/edx-platform).
2. Click **Join team** button at the right-top

### Create API to get access
1. Click **User Avatar** > **User Settings**.
2. On right navigation, click **API token**.
3. Click **Generate a token**, then copy the **API token**.

## Update Translation EdX

### Pull releasing languages
1. Switch to edxapp user
```
$ sudo su edxapp -s /bin/bash
$ cd ~
$ source edxapp_env
```

2. Configure transifexrc file
Create a new /edx/app/edxapp/.transifexrc file if not existed. And update keys as below
```
[https://www.transifex.com]
api_hostname = https://api.transifex.com
hostname = https://www.transifex.com
password = <created above steps>
username = api
```

3. To enable all languages you want. Just uncommented language codes, which you want to enable, on **locales** section in *conf/locale/config.yaml*

4. Pull latest translation
```
# pull all
$ tx pull --all --parallel  # pull translation without reviewed
# or pull one language
$ tx pull --parallel -l <your-langs-are-separated-by-comma>
```

5. Generate i18n
```
$ paver i18n_generate
```

6. [Optional] Update assets
```
$ paver update_assets lms cms --settings=<aws/production> --themes=<your-themes>
```

## Issues
1. ValueError: plural forms expression could be dangerous
```
raceback (most recent call last):
  File "manage.py", line 118, in <module>
    startup.run()
  File "/edx/app/edxapp/edx-platform/lms/startup.py", line 19, in run
    django.setup()
  File "/edx/app/edxapp/venvs/edxapp/local/lib/python2.7/site-packages/django/__init__.py", line 27, in setup
    apps.populate(settings.INSTALLED_APPS)
  File "/edx/app/edxapp/venvs/edxapp/local/lib/python2.7/site-packages/django/apps/registry.py", line 108, in populate
    app_config.import_models()
  File "/edx/app/edxapp/venvs/edxapp/local/lib/python2.7/site-packages/django/apps/config.py", line 202, in import_models
    self.models_module = import_module(models_module_name)
  File "/usr/lib/python2.7/importlib/__init__.py", line 37, in import_module
    __import__(name)
  File "/edx/app/edxapp/venvs/edxapp/local/lib/python2.7/site-packages/django/contrib/auth/models.py", line 103, in <module>
    class Group(models.Model):
  File "/edx/app/edxapp/venvs/edxapp/local/lib/python2.7/site-packages/django/db/models/base.py", line 162, in __new__
    new_class.add_to_class(obj_name, obj)
  File "/edx/app/edxapp/venvs/edxapp/local/lib/python2.7/site-packages/django/db/models/base.py", line 325, in add_to_class
    value.contribute_to_class(cls, name)
  File "/edx/app/edxapp/venvs/edxapp/local/lib/python2.7/site-packages/django/db/models/fields/related.py", line 1648, in contribute_to_class
    self.remote_field.through = create_many_to_many_intermediary_model(self, cls)
  File "/edx/app/edxapp/venvs/edxapp/local/lib/python2.7/site-packages/django/db/models/fields/related.py", line 1104, in create_many_to_many_intermediary_model
    'verbose_name': _('%(from)s-%(to)s relationship') % {'from': from_, 'to': to},
  File "/edx/app/edxapp/venvs/edxapp/local/lib/python2.7/site-packages/django/utils/functional.py", line 162, in __mod__
    return six.text_type(self) % rhs
  File "/edx/app/edxapp/venvs/edxapp/local/lib/python2.7/site-packages/django/utils/functional.py", line 119, in __text_cast
    return func(*self.__args, **self.__kw)
  File "/edx/app/edxapp/venvs/edxapp/local/lib/python2.7/site-packages/django/utils/translation/__init__.py", line 89, in ugettext
    return _trans.ugettext(message)
  File "/edx/app/edxapp/venvs/edxapp/local/lib/python2.7/site-packages/django/utils/translation/trans_real.py", line 345, in ugettext
    return do_translate(message, 'ugettext')
  File "/edx/app/edxapp/venvs/edxapp/local/lib/python2.7/site-packages/django/utils/translation/trans_real.py", line 321, in do_translate
    _default = _default or translation(settings.LANGUAGE_CODE)
  File "/edx/app/edxapp/venvs/edxapp/local/lib/python2.7/site-packages/django/utils/translation/trans_real.py", line 228, in translation
    _translations[language] = DjangoTranslation(language)
  File "/edx/app/edxapp/venvs/edxapp/local/lib/python2.7/site-packages/django/utils/translation/trans_real.py", line 131, in __init__
    self._add_local_translations()
  File "/edx/app/edxapp/venvs/edxapp/local/lib/python2.7/site-packages/django/utils/translation/trans_real.py", line 183, in _add_local_translations
    translation = self._new_gnu_trans(localedir)
  File "/edx/app/edxapp/venvs/edxapp/local/lib/python2.7/site-packages/django/utils/translation/trans_real.py", line 156, in _new_gnu_trans
    fallback=use_null_fallback)
  File "/usr/lib/python2.7/gettext.py", line 496, in translation
    t = _translations.setdefault(key, class_(fp))
  File "/usr/lib/python2.7/gettext.py", line 182, in __init__
    self._parse(fp)
  File "/usr/lib/python2.7/gettext.py", line 318, in _parse
    self.plural = c2py(plural)
  File "/usr/lib/python2.7/gettext.py", line 95, in c2py
    raise ValueError, 'plural forms expression could be dangerous'
ValueError: plural forms expression could be dangerous
```
- Resolve: Change *Plural-Forms: nplurals=INTEGER; plural=EXPRESSION;\n* to *Plural-Forms: nplurals=2; plural=(n != 1);\n*
```
$ grep -rn INTEGER conf/locale/
```

2. Locale is incomplete
```
Traceback (most recent call last):
  File "/edx/app/edxapp/venvs/edxapp/bin/i18n_tool", line 11, in <module>
    sys.exit(main())
  File "/edx/app/edxapp/venvs/edxapp/local/lib/python2.7/site-packages/i18n/main.py", line 60, in main
    return module.main()
  File "/edx/app/edxapp/venvs/edxapp/local/lib/python2.7/site-packages/i18n/__init__.py", line 51, in __call__
    return self.run(args)
  File "/edx/app/edxapp/venvs/edxapp/local/lib/python2.7/site-packages/i18n/generate.py", line 189, in run
    execute(compile_cmd, working_directory=configuration.root_dir, stderr=stderr)
  File "/edx/app/edxapp/venvs/edxapp/local/lib/python2.7/site-packages/i18n/execute.py", line 21, in execute
    sp.check_call(command, cwd=working_directory, stderr=stderr, shell=True)
  File "/usr/lib/python2.7/subprocess.py", line 541, in check_call
    raise CalledProcessError(retcode, cmd)
subprocess.CalledProcessError: Command 'django-admin.py compilemessages -v0' returned non-zero exit status 1
```
- Resolve: run below command and rm locale language directories which raised exception. It'll like */edx/app/edxapp/edx-platform/conf/locale/<locale-lang>*
```
$ django-admin.py compilemessages -v0
```

3. Missing locale
```
INFO:i18n.execute:django-admin.py compilemessages -v0
INFO:i18n.generate:Copying mapped locale /edx/app/edxapp/edx-platform/conf/locale/zh_CN/LC_MESSAGES to /edx/app/edxapp/edx-platform/conf/locale/zh_HANS/LC_MESSAGES
Traceback (most recent call last):
  File "/edx/app/edxapp/venvs/edxapp/bin/i18n_tool", line 11, in <module>
    sys.exit(main())
  File "/edx/app/edxapp/venvs/edxapp/local/lib/python2.7/site-packages/i18n/main.py", line 60, in main
    return module.main()
  File "/edx/app/edxapp/venvs/edxapp/local/lib/python2.7/site-packages/i18n/__init__.py", line 51, in __call__
    return self.run(args)
  File "/edx/app/edxapp/venvs/edxapp/local/lib/python2.7/site-packages/i18n/generate.py", line 198, in run
    path.copytree(path(source_dirname), path(dest_dirname))
  File "/usr/lib/python2.7/shutil.py", line 171, in copytree
    names = os.listdir(src)
OSError: [Errno 2] No such file or directory: '/edx/app/edxapp/edx-platform/conf/locale/<your-lang>/LC_MESSAGES'
```
- Resolve: remove your locale or pull a new locale from tranfix.
```
$ tx pull --parallel -l <your-lang>
```

## Reference
- [Transitfex Gettting Started](https://docs.transifex.com/getting-started-1/translators)
