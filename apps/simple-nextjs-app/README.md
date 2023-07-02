# ECS Task Definition

```bash
aws ecs describe-task-definition \
   --task-definition simple-nextjs-app \
   --query taskDefinition > apps/simple-nextjs-app/task-definition.json \
   --region ap-southeast-1
```
