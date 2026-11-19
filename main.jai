#import "Basic";
#import "File";
#import "cli";
#import "task";
#import "File_Utilities";

TASKS_FOLDER :: "./.tasks";
TASK_FILE_NAME :: "task";

main :: () {
    rc := make_directory_if_it_does_not_exist(TASKS_FOLDER);
    if (!rc) return;
    print("[INFO] Successfully created % directory.\n", TASKS_FOLDER);


    // Did all this back and forth trick to parse dumb windows path("\\").Idk if it even works i don't windows machine.
    path := parse_path(_s = sprint("%/%", TASKS_FOLDER, TASK_FILE_NAME), reduce = true);
    fp_read, ok_read := file_open(path_to_string(path), for_writing = false, log_errors = true);
    if !ok_read {
        fp, _ := file_open(path_to_string(path), for_writing = true, log_errors = true);
        file_close(*fp);
        print("[INFO] No task file found,creating one.\n");
        fp_read, ok_read = file_open(path_to_string(path), for_writing = false, log_errors = true);
    }
    path_str := path_to_string(path);
    print("[INFO] Successfully opened % file.\n", path_str);
    defer file_close(*fp_read);

    task_load(*fp_read);

    args: = get_command_line_arguments();
    cmd_parse_args(args);

    // fp, ok := file_open(path_to_string(path), for_writing = true, log_errors = true);
    // assert(ok);
    // defer file_close(*fp);
    // file_seek(fp, 0, .END);


}
