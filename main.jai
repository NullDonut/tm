#import "Basic";
#import "File";
#import "String";
#import "cli";

TASKS_FOLDER :: "./.tasks";
task_array: [..] Task;

Task_Status :: enum {
    TASK_COMPLETED;
    TASK_UNCOMPLETED;
    TASK_IN_PROGRESS;
}

Task :: struct {
    id: int;
    content: string;
    status: Task_Status;
}

main :: () {
    args: = get_command_line_arguments();
    cmd_parse_args(args);
    // rc := make_directory_if_it_does_not_exist(TASKS_FOLDER);
    // if (!rc) return;
    // print("[INFO] Successfully created % directory.\n", TASKS_FOLDER);
    //
    // fp_read, ok_read := file_open("./.tasks/task", for_writing = false, log_errors = true);
    // assert(ok_read);
    //
    // task_load(*fp_read);
    // file_close(*fp_read);
    //
    //
    // fp, ok := file_open("./.tasks/task", for_writing = true, log_errors = true);
    // assert(ok);
    // defer file_close(*fp);
    //
    // // task_add(12, "ss", .TASK_COMPLETED);
    // task_list();
    //
    // //
    // // file_seek(fp, 0, .END);
    // task_save(*fp);
    //

}

task_add :: (id: int, content: string, status: Task_Status = Task_Status.TASK_UNCOMPLETED) {
    array_add(*task_array, Task.{ id, content, status });
}

task_list :: () {
    count := task_array.count;
    if (count == 0) {
        print("No tasks found.");
        return;
    }
    ele: Task;
    for 0..count - 1 {
        ele = task_array[it];
        print("% % %\n", ele.id, ele.content, task_status_to_string(ele.status));
    }
}

task_status_to_string :: (status: Task_Status) -> string {
    if status == .TASK_COMPLETED {
        return "Completed";
    } else if status == .TASK_IN_PROGRESS {
        return "In progress";
    } else {
        return "Pending";
    }
}

task_string_to_status :: (s: string) -> Task_Status {
    if s == "Completed" {
        return .TASK_COMPLETED;
    } else if s == "In progress" {
        return .TASK_IN_PROGRESS;
    } else {
        return .TASK_UNCOMPLETED;
    }
}

task_to_string :: (t: Task) -> string {
    builder: String_Builder;
    defer free_buffers(*builder);

    print_to_builder(*builder, "%|%|%\n", t.id, t.content, task_status_to_string(t.status));

    return builder_to_string(*builder);
}

task_from_string :: (s: string) -> Task {
    parts := split(s, "|");
    id, ok, _ := to_integer(parts[0]);
    if (!ok) print(
        "Error Occured in parsing the saved data."
    );
    content := parts[1];
    status := task_string_to_status(parts[2]);
    // print("% % %\n", id, content, status);
    return .{
        id, content, status
    }
}

task_save :: (fp: *File) {
    for task_array {
        ele := task_to_string(it);
        assert(file_write(fp, ele));
    }
}

task_load :: (fp: *File) {
    t: Task;
    rest, read_ok := read_entire_file(fp);
    assert(read_ok);
    parts := split(rest, #char "\n");
    for 0..parts.count - 2 {
        t = task_from_string(parts[it]);
        array_add(*task_array, t);
    }
}
