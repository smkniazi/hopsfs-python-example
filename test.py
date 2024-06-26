import pydoop.hdfs as hdfs

print("-------- Listing ----------");
t = hdfs.ls('/');
print(t)

print("-------- Mkdir ----------");

hdfs.mkdir("/tmp")

print("-------- Delete a File ----------");

hdfs_path = "/tmp/test_file.txt"

hdfs.rm(hdfs_path);

print("-------- Write a File ----------");

# Function to generate 1MB of data
def generate_data(size_in_mb):
    return "a" * (size_in_mb * 1024 * 1024)  

# Function to write data to HDFS
def write_to_hdfs(hdfs_path, data):
    try:
        with hdfs.open(hdfs_path, 'w') as f:
            s=f.write(data.encode('utf-8'))
            f.close()
        print(f"File written to {hdfs_path} successfully.")
    except Exception as e:
        print(f"An error occurred during write: {e}")

data = generate_data(10)

write_to_hdfs(hdfs_path, data)

print("-------- Read a File ----------");

# Function to read data from HDFS
def read_from_hdfs(hdfs_path):
    try:
        with hdfs.open(hdfs_path, 'r') as f:
            data = f.read().decode('utf-8')
        print(f"File read from {hdfs_path} successfully.")
        return data
    except Exception as e:
        print(f"An error occurred during read: {e}")
        return None

# Function to verify the data
def verify_data(original_data, read_data):
    if original_data == read_data:
        print("Data verification successful: Data matches.")
    else:
        print("Data verification failed: Data does not match.")

read_data = read_from_hdfs(hdfs_path)

verify_data(data, read_data)



