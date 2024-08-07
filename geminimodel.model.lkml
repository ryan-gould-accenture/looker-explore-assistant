connection: "explore-assistant-extension"

include: "/views/**/*.view.lkml"              # include all views in the views/ folder in this project
# include: "/**/*.view.lkml"                 # include all views in this project
# include: "my_dashboard.dashboard.lookml"   # include a LookML dashboard called my_dashboard

# # Select the views that should be a part of this model,
# # and define the joins that connect them together.
#
# explore: order_items {
#   join: orders {
#     relationship: many_to_one
#     sql_on: ${orders.id} = ${order_items.order_id} ;;
#   }
#
#   join: users {
#     relationship: many_to_one
#     sql_on: ${users.id} = ${orders.user_id} ;;
#   }
# }

datagroup: gemini_explore_assistant_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: gemini_explore_assistant_default_datagroup

#explore: lookertestv8 {view_name: lookertestv8 {}}
#explore: demo_gemini_retail_data {}

explore: targeting_data_1 {view_name: targeting_data_1}
