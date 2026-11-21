#import "File";
#import "Basic";
#import "id";

Task_Status :: enum {
    TASK_COMPLETED;
    TASK_UNCOMPLETED;
    TASK_IN_PROGRESS;
}

Task :: struct {
    id: string;
    content: string;
    status: Task_Status;
}

task_array: [..] Task;

task_add :: (id: string, content: string, status: Task_Status = Task_Status.TASK_UNCOMPLETED) {
    array_add(*task_array, Task.{ id, content, status });
    folder_name := tprint("./tasks/%", id);
    main_file_name := tprint("%/main.md", folder_name);
    make_directory_if_it_does_not_exist(folder_name, recursive = true);
    print("%\n", main_file_name);
    fp, ok := file_open(main_file_name, for_writing = true, log_errors = true);
    assert(ok);
    defer file_close(*fp);
    assert(file_write(*fp, content));
}

task_find :: (id: string) -> s64 {
    for task_array {
        if it.id == id {
            return it_index + 1;
        }
    }
    return -1;
}

task_list :: () {
    count := task_array.count;
    if (count == 0) {
        print("[INFO] No tasks found.\n");
        return;
    }
    ele: Task;
    for 0..count - 1 {
        ele = task_array[it];
        SPACES := 24;
        SPACES -= ele.id.count;
        print("[%]", ele.id);
        for 0..SPACES - 1 {
            print(" ");
        }
        print("% (%)\n", ele.content, task_status_to_string(ele.status));
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


task_load :: () {
    t: Task;
    dirs_in_save := directory_parsing("tasks");
    print("[INFO] Tasks list: %\n", dirs_in_save);
    for dirs_in_save {
        id := it;
        folder_name := tprint("./tasks/%", id);
        main_file_name := tprint("%/main.md", folder_name);
        fp, ok := file_open(main_file_name, for_writing = false, log_errors = true);
        assert(ok);
        defer file_close(*fp);
        rest, read_ok := read_entire_file(fp);
        assert(read_ok);
        t = .{
            id, rest, .TASK_UNCOMPLETED
        };
        array_add(*task_array, t);
    }
    print("[INFO] Loaded tasks folders successfully.\n");
}
