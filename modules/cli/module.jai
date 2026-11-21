#import "Basic";
#import "task";
#import "id";

// Functions declartions and implementations
#scope_file cmd_help :: () {
    print("Unknown command\n");
    exit(0);
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
    } else if main_command_flag == "skip" {
        cmd_skip();
    } else if main_command_flag == "find" {
        cmd_find(args);
    } else {
        cmd_help();
    }
}

#scope_file cmd_add :: (args: [] string) {
    if (args.count < 3) {
        print("[ERROR] Insufficient arguments\n");
        return;
    }
    print("%\n\n", "[INFO] Add mode");
    for 2..args.count - 1 {
        print("Adding task: %\n", args[it]);
        task_add(hex_gen(6), args[it]);
    }
    print("\n");
}

#scope_file cmd_find :: (args: [] string) {
    if args.count < 3 {
        print("[ERROR] Insufficient arguments\n");
        return;
    }
    print("%\n", "[INFO] Find mode");
    id: string = args[2];
    _idx: Find_Result = task_find(id);
}

#scope_file cmd_list :: () {
    print("%\n\n", "[INFO] List mode");
    task_list();
    print("\n");
}

#scope_file cmd_skip :: () {
    print("%\n", "s");
}
