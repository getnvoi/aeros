import { application } from "ui/controllers/application";
import { eagerLoadControllersFrom } from "ui/controllers/loader";

// Load component controllers
eagerLoadControllersFrom("ui/components", application);
