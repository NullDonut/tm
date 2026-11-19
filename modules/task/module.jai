#import "File";
#import "Basic";
#import "String";

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

task_to_string :: (t: Task) -> string {
    builder: String_Builder;
    defer free_buffers(*builder);

    print_to_builder(*builder, "%|%|%\n", t.id, t.content, task_status_to_string(t.status));

    return builder_to_string(*builder);
}

task_from_string :: (s: string) -> Task {
    parts := split(s, "|");
    id := parts[0];
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
    print("[INFO] Saved to tasks file successfully.\n");
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
    print("[INFO] Loaded tasks file successfully.\n");
}
