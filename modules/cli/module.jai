#import "Basic";
#import "task";
#import "id";


CMD_SHOW_INFO :: false;

// Functions declartions and implementations
#scope_file cmd_help :: () {
    print("Unknown command\n");
    exit(0);
}

#scope_export cmd_info :: (format_string: string, a: ..Any) {
    if CMD_SHOW_INFO {
        frm_str := tprint("[INFO] %", format_string);
        print(frm_str, a);
    }
}

#scope_export cmd_parse_args :: (args: [] string) {
    if args.count <= 1 {
        cmd_help();
    }
    main_command_flag := args[1];
    if main_command_flag == "add" {
        cmd_add(args);
    } else if main_command_flag == "list" {
        cmd_list();
    } else if main_command_flag == "show" {
        cmd_show(args);
    } else if main_command_flag == "remove" {
        cmd_remove(args);
    } else {
        cmd_help();
    }
}

#scope_file cmd_add :: (args: [] string) {
    if (args.count < 3) {
        print("[ERROR] Insufficient arguments\n");
        return;
    }
    cmd_info("%\n\n", "Add mode");
    for 2..args.count - 1 {
        print("Adding task: %\n", args[it]);
        task_add(hex_gen(6), args[it]);
    }
    print("\n");
}

#scope_file cmd_show :: (args: [] string) {
    if args.count < 3 {
        print("[ERROR] Insufficient arguments\n");
        return;
    }
    cmd_info("%\n", "Show mode");
    id: string = args[2];
    task_show(id);
}

#scope_file cmd_remove :: (args: [] string) {
    if args.count < 3 {
        print("[ERROR] Insufficient arguments\n");
        return;
    }
    cmd_info("%\n", "Remove mode");
    id: string = args[2];
    task_remove(id);
}

#scope_file cmd_list :: () {
    cmd_info("%\n\n", "List mode");
    task_list();
    print("\n");
}
