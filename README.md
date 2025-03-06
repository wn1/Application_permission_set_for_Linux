# Application_permission_set_for_Linux
Application permission set for Linux

1.Copy the contents of the folder to the folder with root:root 755 (rwxr-xr-x) rights, make sure that all folders in the path have the same rights. 
If the full path is /application/permission_set/, then the "application" and "permission_set" folders must be with root:root 755 rights

2. Create a link to start_app_plus_permission_cmd.sh

3. Launch the link in the terminal


По-русски
1.Скопируйте содержимое папки в папку с правами root:root 755 (rwxr-xr-x), убедитесь что все папки в пути имеют такие же права. 
Если полный путь /application/permission_set/, то папки "application" и "permission_set" должны быть с правами root:root 755

2. Создайте ссылку на start_app_plus_permission_cmd.sh

3. Запускайте ссылку в терминале

Приложение было создано с целью скрыть кеш браузера от остальных программ.
Идея такая, что для каталогов кеша браузера устанавливаются владелец root и отдельная группа.
Например, для браузера firefox создаётся отдельная группа пользователей permission-firefox.
Потом устанавливается для каталогов ~/.mozilla ~/.cache/mozilla ~/snap/firefox владелец root и группа permission-firefox.
После этого браузер запускается командой sudo -E su -g user_name -G permission-firefox -c "firefox " user_name
То есть для исполнения браузера дополнительно добавляется дополнительная группа permission-firefox и
получается, что он сможет получать доступ к кешу. А остальные программы нет.
sudo и пароль пользователя нужен, чтобы запустить браузер с такой конфигурацией,
потому что группа permission-firefox отдельная и не назначается для текущего пользователя.

Приложение это набор скриптов, дополнительно в нём были добавлены несколько утилит,
но их работоспособность может быть уже не актуальной.
Для запуска браузера нужно ввести его числовой номер (1 - firefox, 12 - yandex-browser и т.п.)

Любое использование только на ваш страх и риск, автор не несет за это ответственности.
Лицензия GPL (см. файл LICENSE)


