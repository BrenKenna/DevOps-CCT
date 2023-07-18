class Task{

    constructor(inTitle, inDescription) {
        this.title = inTitle;
        this.description = inDescription;
    }

    getTitle() {
        return this.title;
    }

    getDescription() {
        return this.description;
    }
}

module.exports = Task;