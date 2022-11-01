mod common;

use diff_log_builder::deserialize_change;
use postgres_db::change_log::Change;
use postgres_db::diff_log::{internal_diff_log_state::sql::InternalDiffLogStateRow, DiffLogEntry};
use std::collections::HashMap;

// include tests generated by `build.rs`, one test per json file in resources/test_changes/
include!(concat!(env!("OUT_DIR"), "/deserialize_change_tests.rs"));
include!(concat!(env!("OUT_DIR"), "/process_changes_tests.rs"));
