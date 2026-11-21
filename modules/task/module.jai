#import "File";
#import "Basic";
#import "id";
#import "cli";
#import "String";
#import "File_Utilities";

// Structs and Enums
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

Find_Status :: enum {
    AMBIGUOS;
    FOUND;
    NOT_FOUND;
}

Find_Result :: struct {
    status: Find_Status = .NOT_FOUND;
    idx: s64 = -1;
    idx_possibles: [..] s64;
}


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

task_find :: (input_id: string) -> Find_Result {
    ft: Find_Result;
    defer array_add(*ft.idx_possibles);
    for task_array {
        if slice(it.id, 0, input_id.count) == input_id {
            array_add(*ft.idx_possibles, it_index);
        }
    }
    if (ft.idx_possibles.count == 1) {
        ft.idx = ft.idx_possibles[0];
        ft.status = .FOUND;
    } else if (ft.idx_possibles.count > 1) {
        ft.idx = -1;
        ft.status = .AMBIGUOS;
    } else {
        ft.idx = -1;
        ft.status = .NOT_FOUND;
    }

    return ft;
}

task_show :: (s: string) {
    ft: Find_Result = task_find(s);
    if (ft.status == .FOUND) {
        ele: Task = task_array[ft.idx];
        print("Task: %\n", ele.content);
        print("ID: %\n", ele.id);
    } else if (ft.status == .AMBIGUOS) {
        print("Multiple elements found from the prefix.\n");
        for ft.idx_possibles {
            task_individual_list(it);
        }
        print("Please use more accurate prefix\n");
    } else {
        print("Not found\n");
    }
}

task_remove :: (s: string) {
    ft: Find_Result = task_find(s);
    if (ft.status == .FOUND) {
        id := task_array[ft.idx].id;
        folder_name := tprint("./tasks/%", id);
        ok := delete_directory_tree(folder_name);
        assert(ok);
        print("Successfully deleted item with id:% \n", id);
    } else if (ft.status == .AMBIGUOS) {
        print("Multiple elements found from the prefix.\n");
        for ft.idx_possibles {
            task_individual_list(it);
        }
        print("Please use more accurate prefix\n");
    } else {
        print("Not found\n");
    }
}

task_list :: () {
    count := task_array.count;
    if (count == 0) {
        print("No tasks found.\n");
        return;
    }
    for 0..count - 1 {
        task_individual_list(it);
    }
}

task_individual_list :: (it: int) {
    ele: Task;
    ele = task_array[it];
    SPACES := 24;
    SPACES -= ele.id.count;
    print("[%]", ele.id);
    for 0..SPACES - 1 {
        print(" ");
    }
    print("% (%)\n", ele.content, task_status_to_string(ele.status));

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
    cmd_info("Tasks list: %\n", dirs_in_save);
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
    cmd_info("Loaded tasks folders successfully.\n");
}
