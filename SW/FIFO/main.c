#define QUEUE_SIZE 16

int main(int argc, char** argv) {
    queue_t example = {0, 0, QUEUE_SIZE, malloc(sizeof(void*) * QUEUE_SIZE)};
  
    // Write until queue is full
    for (int i=0; i<QUEUE_SIZE; i++) {
        int res = queue_write(&example, (void*)(i+1));
        assert((i == QUEUE_SIZE - 1) ? res == -1: res == 0);
    }
    // Read until queue is empty
    for (int i=0; i<QUEUE_SIZE; i++) {
        void* handle = queue_read(&example);
        assert((i == QUEUE_SIZE - 1) ? handle == NULL: handle == (i+1));
    }
}
