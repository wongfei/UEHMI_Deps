cd ggml
git pull
cd ..

set /p llama_hash=<"ggml/scripts/sync-llama.last"
set /p whisper_hash=<"ggml/scripts/sync-whisper.last"

cd llamacpp
git pull
git checkout %llama_hash%
cd ..

cd whispercpp
git pull
git checkout %whisper_hash%
cd ..
