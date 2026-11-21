#import "File";
#import "Basic";
#import "id";
#import "cli";
#import "String";
#import "File_Utilities";
#import "Print_Color";

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
    common_chars_count: int;
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
        ft.common_chars_count = -1;
    } else if (ft.idx_possibles.count > 1) {
        ft.idx = -1;
        ft.status = .AMBIGUOS;
        ft.common_chars_count = input_id.count;
    } else {
        ft.idx = -1;
        ft.status = .NOT_FOUND;
        ft.common_chars_count = 0;
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
            task_individual_list(it, ft.common_chars_count);
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
            task_individual_list(it, ft.common_chars_count);
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
        task_individual_list(it, task_array[it].id.count);
    }
}

task_individual_list :: (it: int, color_count: int) {
    ele: Task;
    ele = task_array[it];
    SPACES := 20;
    SPACES -= ele.id.count;
    print("[");
    coloured_slice: string = slice(ele.id, 0, color_count);
    uncoloured_slice: string = slice(ele.id, color_count, ele.id.count - color_count + 1);
    print_color("%", coloured_slice, color = .GREEN, style = .BOLD);
    print("%", uncoloured_slice);
    print("]");
    for 0..SPACES - 1 {
        print(" ");
    }
    print("%\n", ele.content /** , task_status_to_string(ele.status)**/); // Will be implemented in future

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
