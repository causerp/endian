package endian

import endian.utils.ReadEndian
import std.binary.{BigEndianOrder, LittleEndianOrder}
import std.io.{InputStream, Seekable, SeekPosition}

private func peekEndian<T, U>(seekableStream: T): ?U where T <: InputStream & Seekable,
    U <: CType & BigEndianOrder<U> & LittleEndianOrder<U> {
    let buffer = Array<Byte>(Int64(sizeOf<U>()), repeat: 0)
    let readBytes = seekableStream.read(buffer)
    if (readBytes > 0) {
        seekableStream.seek(Current(-readBytes))
    }
    if (readBytes == buffer.size) {
        return @ReadEndian[U](buffer)
    }
    return None
}

private func peekBigEndian<T, U>(seekableStream: T): ?U where T <: InputStream & Seekable,
    U <: CType & BigEndianOrder<U> {
    let buffer = Array<Byte>(Int64(sizeOf<U>()), repeat: 0)
    let readBytes = seekableStream.read(buffer)
    if (readBytes > 0) {
        seekableStream.seek(Current(-readBytes))
    }
    if (readBytes == buffer.size) {
        return U.readBigEndian(buffer)
    }
    return None
}

private func peekLittleEndian<T, U>(seekableStream: T): ?U where T <: InputStream & Seekable,
    U <: CType & LittleEndianOrder<U> {
    let buffer = Array<Byte>(Int64(sizeOf<U>()), repeat: 0)
    let readBytes = seekableStream.read(buffer)
    if (readBytes > 0) {
        seekableStream.seek(Current(-readBytes))
    }
    if (readBytes == buffer.size) {
        return U.readLittleEndian(buffer)
    }
    return None
}

private func readEndian<U>(inputStream: InputStream): ?U where U <: CType & BigEndianOrder<U> & LittleEndianOrder<U> {
    let buffer = Array<Byte>(Int64(sizeOf<U>()), repeat: 0)
    if (inputStream.read(buffer) == buffer.size) {
        return @ReadEndian[U](buffer)
    }
    return None
}

private func readBigEndian<U>(inputStream: InputStream): ?U where U <: CType & BigEndianOrder<U> {
    let buffer = Array<Byte>(Int64(sizeOf<U>()), repeat: 0)
    if (inputStream.read(buffer) == buffer.size) {
        return U.readBigEndian(buffer)
    }
    return None
}

private func readLittleEndian<U>(inputStream: InputStream): ?U where U <: CType & LittleEndianOrder<U> {
    let buffer = Array<Byte>(Int64(sizeOf<U>()), repeat: 0)
    if (inputStream.read(buffer) == buffer.size) {
        return U.readLittleEndian(buffer)
    }
    return None
}

/**
 * Endian reader base class that implements both InputStream and Seekable interfaces.
 */
public abstract class BaseEndianReader<T> <: InputStream & Seekable where T <: InputStream & Seekable {
    protected let inputStream: T

    public init(input: T) {
        inputStream = input
    }

    public override func read(buffer: Array<UInt8>): Int64 {
        inputStream.read(buffer)
    }

    public override prop length: Int64 {
        get() {
            inputStream.length
        }
    }

    public override prop position: Int64 {
        get() {
            inputStream.position
        }
    }

    public override prop remainLength: Int64 {
        get() {
            inputStream.remainLength
        }
    }

    public override func seek(sp: SeekPosition): Int64 {
        inputStream.seek(sp)
    }
}

/**
 * Endian reader base class that implements the InputStream interface.
 */
public abstract class BaseEndianInputStream<T> <: InputStream where T <: InputStream {
    protected let inputStream: T

    public init(input: T) {
        inputStream = input
    }

    public override func read(buffer: Array<UInt8>): Int64 {
        inputStream.read(buffer)
    }
}

/**
 * Native endian reader class for streamable and seekable objects (current system endian).
 */
public class EndianReader<T> <: BaseEndianReader<T> where T <: InputStream & Seekable {
    public init(input: T) {
        super(input)
    }

    public func peek<U>(): ?U where U <: CType & BigEndianOrder<U> & LittleEndianOrder<U> {
        peekEndian(inputStream)
    }

    public func peekBigEndian<U>(): ?U where U <: CType & BigEndianOrder<U> {
        peekBigEndian(inputStream)
    }

    public func peekLittleEndian<U>(): ?U where U <: CType & LittleEndianOrder<U> {
        peekLittleEndian(inputStream)
    }

    public func read<U>(): ?U where U <: CType & BigEndianOrder<U> & LittleEndianOrder<U> {
        readEndian(inputStream)
    }

    public func readBigEndian<U>(): ?U where U <: CType & BigEndianOrder<U> {
        readBigEndian(inputStream)
    }

    public func readLittleEndian<U>(): ?U where U <: CType & LittleEndianOrder<U> {
        readLittleEndian(inputStream)
    }
}

/**
 * Native endian class for streamable objects (current system endian).
 */
public class EndianInputStream<T> <: BaseEndianInputStream<T> where T <: InputStream {
    public init(input: T) {
        super(input)
    }

    public func read<U>(): ?U where U <: CType & BigEndianOrder<U> & LittleEndianOrder<U> {
        readEndian(inputStream)
    }

    public func readBigEndian<U>(): ?U where U <: CType & BigEndianOrder<U> {
        readBigEndian(inputStream)
    }

    public func readLittleEndian<U>(): ?U where U <: CType & LittleEndianOrder<U> {
        readLittleEndian(inputStream)
    }
}

/**
 * Big endian reader class for streamable and seekable objects.
 */
public class BigEndianReader<T> <: BaseEndianReader<T> where T <: InputStream & Seekable {
    public init(input: T) {
        super(input)
    }

    public func peek<U>(): ?U where U <: CType & BigEndianOrder<U> {
        peekBigEndian(inputStream)
    }

    public func read<U>(): ?U where U <: CType & BigEndianOrder<U> {
        readBigEndian(inputStream)
    }
}

/**
 * Big endian class for streamable objects.
 */
public class BigEndianInputStream<T> <: BaseEndianInputStream<T> where T <: InputStream {
    public init(input: T) {
        super(input)
    }

    public func read<U>(): ?U where U <: CType & BigEndianOrder<U> {
        readBigEndian(inputStream)
    }
}

/**
 * Little endian class for streamable and seekable objects.
 */
public class LittleEndianReader<T> <: BaseEndianReader<T> where T <: InputStream & Seekable {
    public init(input: T) {
        super(input)
    }

    public func peek<U>(): ?U where U <: CType & LittleEndianOrder<U> {
        peekLittleEndian(inputStream)
    }

    public func read<U>(): ?U where U <: CType & LittleEndianOrder<U> {
        readLittleEndian(inputStream)
    }
}

/**
 * Little endian class for streamable objects.
 */
public class LittleEndianInputStream<T> <: BaseEndianInputStream<T> where T <: InputStream {
    public init(input: T) {
        super(input)
    }

    public func read<U>(): ?U where U <: CType & LittleEndianOrder<U> {
        readLittleEndian(inputStream)
    }
}
